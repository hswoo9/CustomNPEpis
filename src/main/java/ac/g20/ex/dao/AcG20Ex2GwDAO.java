package ac.g20.ex.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("AcG20Ex2GwDAO")
public class AcG20Ex2GwDAO extends EgovComAbstractDAO {
	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger( AcG20Ex2GwDAO.class );
	
	@Resource(name = "AcG20Ex2ErpDAO")
	private AcG20Ex2ErpDAO acG20Ex2ErpDAO;
	
	public String insertConsDoc(HashMap<String, Object> paramMap) {
		return (String)insert("AcG20Ex2Gw.insertConsDoc", paramMap);	
	}
	
	public void updateConsDoc(HashMap<String, Object> paramMap) {
		update("AcG20Ex2Gw.updateConsDoc", paramMap);	
	}
	
	public String insertConsHead(HashMap<String, Object> paramMap) {
		return (String)insert("AcG20Ex2Gw.insertConsHead", paramMap);	
	}

	public void updateConsHead(HashMap<String, Object> paramMap) {
		update("AcG20Ex2Gw.updateConsHead", paramMap);	
	}

	public Object getPurcContH(HashMap<String, Object> paramMap) {
		return list("AcG20Ex2Gw.getPurcContH", paramMap);
	}
	
	public Object getPurcReqH(HashMap<String, Object> paramMap) {
		return list("AcG20Ex2Gw.getPurcReqH", paramMap);
	}

	public Abdocu_H getAbdocuH(Abdocu_H abdocu_H) {
		return (Abdocu_H)select("AcG20Ex2Gw.getAbdocuH", abdocu_H);
	}

	
	@SuppressWarnings("unchecked")
	public List<Abdocu_B> getPurcReqB(Abdocu_H abdocu_H) throws Exception {
		return list("AcG20Ex2Gw.getPurcReqB", abdocu_H);
	}

	public int deleteAbdocu_B(Abdocu_B abdocu_B) {
		return delete("AcG20Ex2Gw.deleteAbdocu_B", abdocu_B);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, String> getBudgetConsUseAmt(Map<String, String> paramMap) {
		HashMap<String, String> gwBudgetConsAmt = (HashMap<String, String>) select("AcG20Ex2Gw.getBudgetConsUseAmt", paramMap);
		if ( gwBudgetConsAmt == null ) {
			gwBudgetConsAmt = new HashMap<String, String>();
			gwBudgetConsAmt.put( "resErpBudgetSeq", "-1" );
			gwBudgetConsAmt.put( "resErpBudgetSeq", "-1" );
			gwBudgetConsAmt.put( "consStdAmt", "0" );
			gwBudgetConsAmt.put( "consTaxAmt", "0" );
			gwBudgetConsAmt.put( "consAmt", "0" );
			gwBudgetConsAmt.put( "resStdAmt", "0" );
			gwBudgetConsAmt.put( "resTaxAmt", "0" );
			gwBudgetConsAmt.put( "resAmt", "0" );
			gwBudgetConsAmt.put( "balanceStdAmt", "0" );
			gwBudgetConsAmt.put( "balanceTaxAmt", "0" );
			gwBudgetConsAmt.put( "balanceAmt", "0" );
		}
		return gwBudgetConsAmt;
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, String> getBudgetResUseAmt(Map<String, String> paramMap) {
		HashMap<String, String> gwBudgetResAmt = (HashMap<String, String>) select("AcG20Ex2Gw.getBudgetRefResUseAmt", paramMap);
		if ( gwBudgetResAmt == null ) {
			gwBudgetResAmt = new HashMap<String, String>();
			gwBudgetResAmt.put( "resErpBudgetSeq", "-1" );
			gwBudgetResAmt.put( "resBudgetStdAmt", "0" );
			gwBudgetResAmt.put( "resBudgetTaxAmt", "0" );
			gwBudgetResAmt.put( "resBudgetAmt", "0" );
		}
		return gwBudgetResAmt;
	}

	public Object insertAbdocu_B(Abdocu_B abdocu_B) {
		// TODO 옵션 코드명 추가 / 금액 수정
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("erp_co_cd", abdocu_B.getErp_co_cd());
		param.put("erp_div_cd", abdocu_B.getDiv_cd2());
		Map<String, Object> result = acG20Ex2ErpDAO.getErpOption(param);
		abdocu_B.setCtl_fg(String.valueOf(result.get("ctl_fg")));
		abdocu_B.setCtl_fg_nm(String.valueOf(result.get("ctl_fg_nm")));
		return insert("AcG20Ex2Gw.insertAbdocu_B", abdocu_B);
	}

	public Object updateAbdocu_B(Abdocu_B abdocu_B) {
		// TODO 옵션 코드명 추가 / 금액 수정
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("erp_co_cd", abdocu_B.getErp_co_cd());
		param.put("erp_div_cd", abdocu_B.getDiv_cd2());
		Map<String, Object> result = acG20Ex2ErpDAO.getErpOption(param);
		abdocu_B.setCtl_fg(String.valueOf(result.get("ctl_fg")));
		abdocu_B.setCtl_fg_nm(String.valueOf(result.get("ctl_fg_nm")));
		return update("AcG20Ex2Gw.updateAbdocu_B", abdocu_B);
	}

	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getPurcReqT(Abdocu_B abdocu_B) {
		return list("AcG20Ex2Gw.getPurcReqT", abdocu_B);
	}

	public int delAbdocu_H(Abdocu_H abdocu_H) {
		return delete("AcG20Ex2Gw.delAbdocu_H", abdocu_H);
	}

	public Object insertAbdocu_T(Abdocu_T abdocu_T) {
		return insert("AcG20Ex2Gw.insertAbdocu_T", abdocu_T);
	}

	public Object updateAbdocu_T(Abdocu_T abdocu_T) {
		return update("AcG20Ex2Gw.updateAbdocu_T", abdocu_T);
	}

	public void updateAbdocuB_ApplyAm(Abdocu_T abdocu_T) {
		update("AcG20Ex2Gw.updateAbdocuB_ApplyAm", abdocu_T);
	}

	public void updatePurcReqB_ApplyAm(Abdocu_T abdocu_T) {
		update("AcG20Ex2Gw.updatePurcReqB_ApplyAm", abdocu_T);		
	}

	public Abdocu_B getAbdocuB_One(String abdocu_b_no) {
		return (Abdocu_B)select("AcG20Ex2Gw.getAbdocuB_One", abdocu_b_no);
	}

	public int deleteAbdocu_T(Abdocu_T abdocu_T) {
		return delete("AcG20Ex2Gw.deleteAbdocu_T", abdocu_T);
	}

	public Abdocu_B getBgtApplyAmSumThis(Abdocu_B abdocu_B) {
		return (Abdocu_B) select("AcG20Ex2Gw.getBgtApplyAmSumThis", abdocu_B);
	}

	public Object getPurcReqHBList(HashMap<String, Object> paramMap) {
		return list("AcG20Ex2Gw.getPurcReqHBList", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getPurcReqTList(HashMap<String, Object> paramMap) {
		return list("AcG20Ex2Gw.getPurcReqTList", paramMap);
	}

	public void makePurcContB(Map<String, String> paraMap) {
		insert("AcG20Ex2Gw.makePurcContB", paraMap);
	}

	public void makePurcContT(Map<String, String> paraMap) {
		insert("AcG20Ex2Gw.makePurcContT", paraMap);
	}

	@SuppressWarnings("unchecked")
	public List<Abdocu_B> getPurcContB(Map<String, Object> map) {
		return list("AcG20Ex2Gw.getPurcContB", map);
	}

	public Object getPurcContHBList(HashMap<String, Object> paramMap) {
		return list("AcG20Ex2Gw.getPurcContHBList", paramMap);
	}

	public void makeContInspTInfo(HashMap<String, Object> requestMap) {
		insert("AcG20Ex2Gw.makeContInspTInfo", requestMap);
	}
	
	public void makeContInspTInfo2(HashMap<String, Object> requestMap) {
		insert("AcG20Ex2Gw.makeContInspTInfo2", requestMap);
	}

	public Object getContInspT(HashMap<String, Object> requestMap) {
		return list("AcG20Ex2Gw.getContInspT", requestMap);
	}

	public Object getAceptAm(HashMap<String, Object> paramMap) {
		return select("AcG20Ex2Gw.getAceptAm", paramMap);
	}

	public void resetAbdocuTMod(HashMap<String, Object> paramMap) {
		update("AcG20Ex2Gw.resetAbdocuTMod", paramMap);		
	}

	public void updateAbdocuTMod(HashMap<String, Object> paramMap) {
		update("AcG20Ex2Gw.updateAbdocuTMod", paramMap);		
	}

	public void resetAbdocuT(Map<String, Object> map) {
		update("AcG20Ex2Gw.resetAbdocuT", map);		
	}
	
	public void updateAbdocuT(Map<String, Object> map) {
		update("AcG20Ex2Gw.updateAbdocuT", map);		
	}

	public void updateAbdocuB_ApplyAm_purc(Map<String, Object> map) {
		update("AcG20Ex2Gw.updateAbdocuB_ApplyAm_purc", map);
	}

	public void updateConsConfferStatus(Map<String, Object> paramMap) {
		update("AcG20Ex2Gw.updateConsConfferStatus", paramMap);
	}
	
	public void updateConsConfferBudgetStatus(Map<String, Object> paramMap) {
		update("AcG20Ex2Gw.updateConsConfferBudgetStatus", paramMap);
	}

	public Object purcContPayListData(Map<String, Object> map) {
		return list("AcG20Ex2Gw.purcContPayListData", map);
	}

	public Object purcContPayListDataTotal(Map<String, Object> map) {
		return select("AcG20Ex2Gw.purcContPayListDataTotal", map);
	}

	public int checkPurcContPayComplete(Map<String, Object> map) {
		return (int)select("AcG20Ex2Gw.checkPurcContPayComplete", map);
	}

	public String insertPurcReqBidding(HashMap<String, Object> map) {
		return (String)insert("AcG20Ex2Gw.insertPurcReqBidding", map);
	}

	public Object purcBiddingData(Map<String, Object> map) {
		return list("AcG20Ex2Gw.purcBiddingData", map);
	}

	public Object purcBiddingDataTotal(Map<String, Object> map) {
		return select("AcG20Ex2Gw.purcBiddingDataTotal", map);
	}

	public Object checkPurcBiddingApproval(Map<String, Object> map) {
		return select("AcG20Ex2Gw.checkPurcBiddingApproval", map);
	}

	public Object selectPurcReqDept(Map<String, Object> map) {
		return select("AcG20Ex2Gw.selectPurcReqDept", map);
	}

	public String insertPurcReqBiddingEvalTr(Map<String, Object> map) {
		return (String)insert("AcG20Ex2Gw.insertPurcReqBiddingEvalTr", map);
	}

	public void insertPurcReqBiddingEvalSubTr(Map<String, Object> map) {
		insert("AcG20Ex2Gw.insertPurcReqBiddingEvalSubTr", map);
	}

	public void deletePurcReqBiddingEvalTr(HashMap<String, Object> map) {
		delete("AcG20Ex2Gw.deletePurcReqBiddingEvalTr", map);
	}

	public void deletePurcReqBiddingEvalSubTr(HashMap<String, Object> map) {
		delete("AcG20Ex2Gw.deletePurcReqBiddingEvalSubTr", map);
	}

	public Object selectPurcReqBiddingEvalTr(Map<String, Object> map) {
		return list("AcG20Ex2Gw.selectPurcReqBiddingEvalTr", map);
	}

	public Object selectPurcReqBiddingEvalSubTr(Map<String, Object> map) {
		return list("AcG20Ex2Gw.selectPurcReqBiddingEvalSubTr", map);
	}

	public Object selectPurcReqBidding(HashMap<String, Object> map) {
		return select("AcG20Ex2Gw.selectPurcReqBidding", map);
	}
	
	public Object selectPurcReqBiddingRefer(HashMap<String, Object> map) {
		return select("AcG20Ex2Gw.selectPurcReqBiddingRefer", map);
	}

	public Object selectRefDoc(HashMap<String, Object> paramMap) {
		return select("AcG20Ex2Gw.selectRefDoc", paramMap);
	}

	public void updatePurcContModReturn(HashMap<String, Object> map) {
		update("AcG20Ex2Gw.updatePurcContModReturn", map);
	}

	public Object insertResTrade(HashMap<String, Object> map) {
		return insert("AcG20Ex2Gw.insertResTrade", map);
	}

	public void deletePurcContPay2(HashMap<String, Object> map) {
		insert("AcG20Ex2Gw.deletePurcContPay2", map);
	}
	
	public void insertPurcContPay2(HashMap<String, Object> map) {
		insert("AcG20Ex2Gw.insertPurcContPay2", map);
	}

	public Object selectCommitteeSeq(HashMap<String, Object> paramMap) {
		return select("AcG20Ex2Gw.selectCommitteeSeq", paramMap);
	}
	
	public Object selectPurcReqBiddingEval(Map<String, Object> resultMap) {
		return list("AcG20Ex2Gw.selectPurcReqBiddingEval", resultMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectPurcReqBiddingT(Map<String, Object> map) {
		return (Map<String, Object>)select("AcG20Ex2Gw.selectPurcReqBiddingT", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPurcReqBiddingTSub(Map<String, Object> biddingT) {
		return list("AcG20Ex2Gw.selectPurcReqBiddingTSub", biddingT);
	}

	public void updatePurcContTr(Map<String, Object> map) {
		update("AcG20Ex2Gw.updatePurcContTr", map);
	}

	public Object selectFormInfo(Map<String, Object> map) {
		return select("AcG20Ex2Gw.selectFormInfo", map);
	}

	public Object updateResHeadNote(Map<String, Object> map) {
		return update("AcG20Ex2Gw.updateResHeadNote", map);
	}
	
	public Object updateResBudgetNote(Map<String, Object> map) {
		return update("AcG20Ex2Gw.updateResBudgetNote", map);
	}

	public Object selectPurcReqBiddingEvalTrSocialBiz(Map<String, Object> map) {
		return select("AcG20Ex2Gw.selectPurcReqBiddingEvalTrSocialBiz", map);
	}

	public int purcContModReqCheck(HashMap<String, Object> requestMap) {
		return (int)select("AcG20Ex2Gw.purcContModReqCheck", requestMap);
	}

}
