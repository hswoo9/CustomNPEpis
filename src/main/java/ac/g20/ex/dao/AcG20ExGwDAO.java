package ac.g20.ex.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.duzon.custom.commcode.dao.CodeDAO;

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
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * @title AcG20ExGwDAO.java
 * @author doban7
 *
 * @date 2016. 9. 5.
 */
@Repository("AcG20ExGwDAO")
public class AcG20ExGwDAO extends EgovComAbstractDAO {
	
	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this.getClass());
	
	@Autowired
	CodeDAO codeDAO;
	@Resource ( name = "AcG20Ex2GwDAO" )
	private AcG20Ex2GwDAO acG20Ex2GwDAO;

	/**
	 * insertAbdocu_H doban7 2016. 9. 5.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	public Object insertAbdocu_H(Abdocu_H abdocu_H) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_H >> AcG20ExGw.insertAbdocu_H");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H >> " + abdocu_H.toString());
		if(abdocu_H.getErp_acisu_dt() == null){
			return insert("AcG20ExGw.insertAbdocu_H", abdocu_H);	
		}else{
			return insert("AcG20ExGw.insertAbdocu_H_busan", abdocu_H);
		}
	}

	/**
	 * updateAbdocu_H doban7 2016. 9. 5.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	public Object updateAbdocu_H(Abdocu_H abdocu_H) {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_H >> AcG20ExGw.updateAbdocu_H");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H >> " + abdocu_H.toString());
		return update("AcG20ExGw.updateAbdocu_H", abdocu_H);
	}

	/**
	 * getAbdocuH doban7 2016. 9. 6.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public Abdocu_H getAbdocuH(Abdocu_H abdocu_H) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuH >> AcG20ExGw.getAbdocu_H");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H >> " + abdocu_H.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getAbdocuH( abdocu_H );
		}else{
			return (Abdocu_H) selectByPk("AcG20ExGw.getAbdocu_H", abdocu_H);
		}
	}

	/**
	 * getAbdocuB doban7 2016. 9. 7.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_B> getAbdocuB_List(Abdocu_H abdocu_H) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuB_List >> AcG20ExGw.getAbdocuB_List");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H >> " + abdocu_H.toString());
		return list("AcG20ExGw.getAbdocuB_List", abdocu_H);
	}

	/**
	 * getBudgetUseAmt doban7 2016. 9. 7.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public HashMap<String, String> getBudgetConsUseAmt(Map<String, String> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getBudgetConsUseAmt >> AcG20ExGw.getBudgetConsUseAmt");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return (HashMap<String, String>) selectByPk("AcG20ExGw.getBudgetConsUseAmt", paramMap);
	}

	/**
	 * getBudgetResUseAmt doban7 2016. 9. 7.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public HashMap<String, String> getBudgetResUseAmt(Map<String, String> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getBudgetResUseAmt >> AcG20ExGw.getBudgetRefResUseAmt");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return (HashMap<String, String>) selectByPk("AcG20ExGw.getBudgetRefResUseAmt", paramMap);
	}

	/**
	 * insertAbdocu_B doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	public Object insertAbdocu_B(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_B >> AcG20ExGw.insertAbdocu_B");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.insertAbdocu_B(abdocu_B);
		}else{
			return insert("AcG20ExGw.insertAbdocu_B", abdocu_B);
		}
	}

	/**
	 * updateAbdocu_B doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	public Object updateAbdocu_B(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_B >> AcG20ExGw.updateAbdocu_B");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.updateAbdocu_B(abdocu_B);
		}else{
			return update("AcG20ExGw.updateAbdocu_B", abdocu_B);
		}
	}

	/**
	 * delAbdocuB doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	public int deleteAbdocu_B(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_B >> AcG20ExGw.deleteAbdocu_B");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.deleteAbdocu_B( abdocu_B );
		}else{
			return delete("AcG20ExGw.deleteAbdocu_B", abdocu_B);
		}
	}

	/**
	 * getAbdocuT doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getAbdocuT_List(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuT_List >> AcG20ExGw.getAbdocuT_List");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return list("AcG20ExGw.getAbdocuT_List", abdocu_B);
	}

	/**
	 * insertAbdocu_T doban7 2016. 9. 8.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	public Object insertAbdocu_T(Abdocu_T abdocu_T) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_T >> AcG20ExGw.insertAbdocu_T");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T abdocu_T >> " + abdocu_T.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.insertAbdocu_T( abdocu_T );
		}else{
			return insert("AcG20ExGw.insertAbdocu_T", abdocu_T);
		}
	}

	/**
	 * updateAbdocu_T doban7 2016. 9. 8.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	public Object updateAbdocu_T(Abdocu_T abdocu_T) {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_T >> AcG20ExGw.updateAbdocu_T");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T abdocu_T >> " + abdocu_T.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.updateAbdocu_T( abdocu_T );
		}else{
			return update("AcG20ExGw.updateAbdocu_T", abdocu_T);
		}
	}

	/**
	 * updateAbdocuB_ApplyAm doban7 2016. 9. 8.
	 * 
	 * @param abdocu_T
	 */
	public void updateAbdocuB_ApplyAm(Abdocu_T abdocu_T) {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocuB_ApplyAm >> AcG20ExGw.updateAbdocuB_ApplyAm");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T abdocu_T >> " + abdocu_T.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		}else{
			update("AcG20ExGw.updateAbdocuB_ApplyAm", abdocu_T);
		}
	}

	/**
	 * getAbdocuB_One doban7 2016. 9. 8.
	 * 
	 * @param abdocu_b_no
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public Abdocu_B getAbdocuB_One(String abdocu_b_no) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuB_One >> AcG20ExGw.getAbdocuB_One");
		LOG.debug("! [G20] AcG20ExGwDAO - String abdocu_b_no >> " + abdocu_b_no.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return (Abdocu_B) acG20Ex2GwDAO.getAbdocuB_One( abdocu_b_no );
		}else{
			return (Abdocu_B) selectByPk("AcG20ExGw.getAbdocuB_One", abdocu_b_no);
		}
	}

	/**
	 * 
	 * deleteAbdocu_T doban7 2016. 9. 7.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	public int deleteAbdocu_T(Abdocu_T abdocu_T) {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_T >> AcG20ExGw.deleteAbdocu_T");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T abdocu_T >> " + abdocu_T.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.deleteAbdocu_T( abdocu_T );
		}else{
			return delete("AcG20ExGw.deleteAbdocu_T", abdocu_T);
		}
	}

	/**
	 * getBgtApplyAmSumThis doban7 2016. 9. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public Abdocu_B getBgtApplyAmSumThis(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - getBgtApplyAmSumThis >> AcG20ExGw.getBgtApplyAmSumThis");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getBgtApplyAmSumThis( abdocu_B );
		}else{
			return (Abdocu_B) selectByPk("AcG20ExGw.getBgtApplyAmSumThis", abdocu_B);
		}
	}

	/**
	 * getBgtApplyAmSumReffer doban7 2016. 9. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public Abdocu_B getBgtApplyAmSumReffer(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - getBgtApplyAmSumReffer >> AcG20ExGw.getBgtApplyAmSumReffer");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return (Abdocu_B) selectByPk("AcG20ExGw.getBgtApplyAmSumReffer", abdocu_B);
	}

	/**
	 * getBudgetMoney_Now doban7 2016. 9. 26.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public HashMap<String, String> getResApplyAmThis(HashMap<String, String> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getResApplyAmThis >> AcG20ExGw.getResApplyAmThis");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return (HashMap<String, String>) selectByPk("AcG20ExGw.getResApplyAmThis", paramMap);
	}

	/**
	 * 
	 * getReferConfer doban7 2016. 9. 29.
	 * 
	 * @param paramMap
	 * @param queryID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getReferConfer(HashMap<String, String> paramMap, String queryID) {
		LOG.debug("! [G20] AcG20ExGwDAO - getReferConfer >> " + queryID);
		 
		/* 권한테이블 존재여부 확인 */
		String existsTable = ((List<HashMap<String, Object>>) list("AcG20ExGw.checkAuthTable", paramMap)).get( 0 ).get( "ifExists" ).toString( ) ; 
		if(existsTable.equals( "1" )){
			/* 권한적용 품의 리스트 출력 */
			return (List<HashMap<String, String>>) list("AcG20ExGw.getReferConferWithAuth", paramMap);	
		}else{
			/* 권한 미적용 품의 리스트 출력 */
			return (List<HashMap<String, String>>) list(queryID, paramMap);
		}
	}

	/**
	 * insertReferConfer_H doban7 2016. 9. 29.
	 * 
	 * @param abdocu_H_Tmp
	 * @return
	 */
	public String insertReferConfer_H(Abdocu_H abdocu_H_Tmp) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertReferConfer_H >> AcG20ExGw.ReferConfer");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_H_Tmp >> " + abdocu_H_Tmp.toString());
		return (String) insert("AcG20ExGw.INSERT-ReferConfer-H", abdocu_H_Tmp);
	}

	/**
	 * selectReferConfer_B doban7 2016. 9. 29.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_B> selectReferConfer_B(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - selectReferConfer_B >> AcG20ExGw.SELECT-ReferConfer-B");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return (List<Abdocu_B>) list("AcG20ExGw.SELECT-ReferConfer-B", abdocu_B);
	}

	/**
	 * insertReferConfer_B doban7 2016. 9. 29.
	 * 
	 * @param t_abdocu_B
	 */
	public String insertReferConfer_B(Abdocu_B t_abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertReferConfer_B >> AcG20ExGw.INSERT-ReferConfer-B");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B t_abdocu_B >> " + t_abdocu_B.toString());
		return (String) insert("AcG20ExGw.INSERT-ReferConfer-B", t_abdocu_B);
	}

	/**
	 * selectReferConfer_T doban7 2016. 9. 29.
	 * 
	 * @param t_abdocu_B
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_T> selectReferConfer_T(Abdocu_B t_abdocu_B) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - selectReferConfer_T >> AcG20ExGw.SELECT-ReferConfer-T");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B t_abdocu_B >> " + t_abdocu_B.toString());
		return (List<Abdocu_T>) list("AcG20ExGw.SELECT-ReferConfer-T", t_abdocu_B);
	}

	/**
	 * insertReferConfer_T doban7 2016. 9. 29.
	 * 
	 * @param t_abdocu_T
	 */
	public String insertReferConfer_T(Abdocu_T t_abdocu_T) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertReferConfer_T >> AcG20ExGw.INSERT-ReferConfer-T");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T t_abdocu_T >> " + t_abdocu_T.toString());
		return (String) insert("AcG20ExGw.INSERT-ReferConfer-T", t_abdocu_T);
	}

	/**
	 * getConferBalance doban7 2016. 9. 29.
	 * 
	 * @param abdocu_b
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String getConferBalance(Abdocu_B abdocu_b) {
		LOG.debug("! [G20] AcG20ExGwDAO - getConferBalance >> AcG20ExGw.getConferBalance");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_b >> " + abdocu_b.toString());
		return (String) selectByPk("AcG20ExGw.getConferBalance", abdocu_b);
	}

	/**
	 * getUseSpendStandingCnt doban7 2016. 9. 29.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public int getUseSpendStandingCnt(HashMap<String, String> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getUseSpendStandingCnt >> AcG20ExGw.getUseSpendStandingCnt");
		LOG.debug("! [G20] AcG20ExGwDAO - HashMap<String, String> paramMap >> " + paramMap.toString());
		return (Integer) selectByPk("AcG20ExGw.getUseSpendStandingCnt", paramMap);
	}

	/**
	 * insertBudgetInfo doban7 2016. 9. 29.
	 * 
	 * @param abdocu_B
	 */
	public void insertBudgetInfo(Abdocu_B abdocu_B) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertBudgetInfo >> -");
	}

	/**
	 * getReturnConferBudgetRollBackInfo doban7 2016. 9. 29.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public Abdocu_B getReturnConferBudgetRollBackInfo(Abdocu_B abdocu_B) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getReturnConferBudgetRollBackInfo >> AcG20ExGw.getReturnConferBudgetRollBackInfo");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return (Abdocu_B) selectByPk("AcG20ExGw.getReturnConferBudgetRollBackInfo", abdocu_B);
	}

	/**
	 * getACardSungin_List doban7 2016. 10. 1.
	 * 
	 * @param aCardVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<ACardVO> getACardSungin_List(ACardVO aCardVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getACardSungin_List >> AcG20ExGw.getACardSungin_List");
		LOG.debug("! [G20] AcG20ExGwDAO - ACardVO aCardVO >> " + aCardVO.toString());
		return list("AcG20ExGw.getACardSungin_List", aCardVO);
	}

	/**
	 * getACardList doban7 2016. 10. 2.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getACardList(HashMap<String, Object> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getACardList >> AcG20ExGw.getACardList");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return (List<HashMap<String, String>>) list("AcG20ExGw.getACardList", paramMap);
	}

	/**
	 * delACardSungin doban7 2016. 10. 2.
	 * 
	 * @param aCardVO
	 */
	public void deleteACardSungin(ACardVO aCardVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteACardSungin >> AcG20ExGw.deleteACardSungin");
		LOG.debug("! [G20] AcG20ExGwDAO - ACardVO aCardVO >> " + aCardVO.toString());
		delete("AcG20ExGw.deleteACardSungin", aCardVO);
	}

	/**
	 * insertAbdocu_T_ACard doban7 2016. 10. 2.
	 * 
	 * @param aCardVO
	 * @return
	 */
	public String insertAbdocu_T_ACard(ACardVO aCardVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_T_ACard >> AcG20ExGw.insertAbdocu_T_ACard");
		LOG.debug("! [G20] AcG20ExGwDAO - ACardVO aCardVO >> " + aCardVO.toString());
		return (String) insert("AcG20ExGw.insertAbdocu_T_ACard", aCardVO);
	}

	/**
	 * insertACardSungin doban7 2016. 10. 2.
	 * 
	 * @param aCardVO
	 */
	public void insertACardSungin(ACardVO aCardVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertACardSungin >> AcG20ExGw.insertACardSungin");
		LOG.debug("! [G20] AcG20ExGwDAO - ACardVO aCardVO >> " + aCardVO.toString());
		insert("AcG20ExGw.insertACardSungin", aCardVO);
	}

	/** #################################################################### **/
	/**
	 * getAbdocuTH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_h
	 * @return
	 */
	public Abdocu_TH getAbdocuTH(Abdocu_H abdocu_h) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuTH >> AcG20ExGw.getAbdocuTH");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_h >> " + abdocu_h.toString());
		return (Abdocu_TH) select("AcG20ExGw.getAbdocuTH", abdocu_h);
	}

	/**
	 * getAbdocuTD_List doban7 2016. 10. 3.
	 * 
	 * @param abdocu_h
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_TD> getAbdocuTD_List(Abdocu_H abdocu_h) {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuTD_List >> AcG20ExGw.getAbdocuTD_List");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_h >> " + abdocu_h.toString());
		return list("AcG20ExGw.getAbdocuTD_List", abdocu_h);
	}

	/**
	 * getAbdocuTD2_List doban7 2016. 10. 3.
	 * 
	 * @param abdocu_h
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_TD2> getAbdocuTD2_List(Abdocu_H abdocu_h) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuTD2_List >> AcG20ExGw.getAbdocuTD2_List");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_h >> " + abdocu_h.toString());
		return list("AcG20ExGw.getAbdocuTD2_List", abdocu_h);
	}

	/**
	 * insertAbdocu_TH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_th
	 * @return
	 */
	public Object insertAbdocu_TH(Abdocu_TH abdocu_th) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_TH >> AcG20ExGw.insertAbdocu_TH");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TH abdocu_th >> " + abdocu_th.toString());
		return insert("AcG20ExGw.insertAbdocu_TH", abdocu_th);
	}

	/**
	 * updateAbdocu_TH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_th
	 */
	public int updateAbdocu_TH(Abdocu_TH abdocu_th) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_TH >> AcG20ExGw.updateAbdocu_TH");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TH abdocu_th >> " + abdocu_th.toString());
		return update("AcG20ExGw.updateAbdocu_TH", abdocu_th);

	}

	/**
	 * deleteAbdocu_TH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_th
	 * @return
	 */
	public int deleteAbdocu_TH(Abdocu_TH abdocu_th) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_TH >> AcG20ExGw.deleteAbdocu_TH");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TH abdocu_th >> " + abdocu_th.toString());
		return delete("AcG20ExGw.deleteAbdocu_TH", abdocu_th);
	}

	/**
	 * updateAbdocu_TD doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td
	 * @return
	 */
	public int updateAbdocu_TD(Abdocu_TD abdocu_td) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_TD >> AcG20ExGw.updateAbdocu_TD");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD abdocu_td >> " + abdocu_td.toString());
		return update("AcG20ExGw.updateAbdocu_TD", abdocu_td);
	}

	/**
	 * insertAbdocu_TD doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td
	 * @return
	 */
	public Object insertAbdocu_TD(Abdocu_TD abdocu_td) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_TD >> AcG20ExGw.insertAbdocu_TD");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD abdocu_td >> " + abdocu_td.toString());
		return update("AcG20ExGw.insertAbdocu_TD", abdocu_td);
	}

	/**
	 * deleteAbdocu_TD doban7 2016. 10. 3.
	 * 
	 * @param abdocu_td
	 */
	public int deleteAbdocu_TD(Abdocu_TD abdocu_td) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_TD >> AcG20ExGw.deleteAbdocu_TD");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD abdocu_td >> " + abdocu_td.toString());
		return delete("AcG20ExGw.deleteAbdocu_TD", abdocu_td);

	}

	/**
	 * updateAbdocu_TD2 doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td2
	 * @return
	 */
	public int updateAbdocu_TD2(Abdocu_TD2 abdocu_td2) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_TD2 >> AcG20ExGw.updateAbdocu_TD2");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD2 abdocu_td2 >> " + abdocu_td2.toString());
		return update("AcG20ExGw.updateAbdocu_TD2", abdocu_td2);
	}

	/**
	 * insertAbdocu_TD2 doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td2
	 * @return
	 */
	public Object insertAbdocu_TD2(Abdocu_TD2 abdocu_td2) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_TD2 >> AcG20ExGw.insertAbdocu_TD2");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD2 abdocu_td2 >> " + abdocu_td2.toString());
		return update("AcG20ExGw.insertAbdocu_TD2", abdocu_td2);
	}

	/**
	 * deleteAbdocu_TD2 doban7 2016. 10. 3.
	 * 
	 * @param abdocu_td2
	 */
	public int deleteAbdocu_TD2(Abdocu_TD2 abdocu_td2) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_TD2 >> AcG20ExGw.deleteAbdocu_TD2");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_TD2 abdocu_td2 >> " + abdocu_td2.toString());
		return delete("AcG20ExGw.deleteAbdocu_TD2", abdocu_td2);
	}

	/**
	 * getAbdocuD_List doban7 2016. 10. 4.
	 * 
	 * @param abdocu_h
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_D> getAbdocuD_List(Abdocu_H abdocu_h) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getAbdocuD_List >> AcG20ExGw.getAbdocuD_List");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_h >> " + abdocu_h.toString());
		return list("AcG20ExGw.getAbdocuD_List", abdocu_h);
	}

	/**
	 * updateAbdocu_D doban7 2016. 10. 4.
	 * 
	 * @param abdocu_d
	 * @return
	 */
	public int updateAbdocu_D(Abdocu_D abdocu_d) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocu_D >> AcG20ExGw.updateAbdocu_D");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_D abdocu_d >> " + abdocu_d.toString());
		return update("AcG20ExGw.updateAbdocu_D", abdocu_d);
	}

	/**
	 * insertAbdocu_D doban7 2016. 10. 4.
	 * 
	 * @param abdocu_d
	 * @return
	 */
	public Object insertAbdocu_D(Abdocu_D abdocu_d) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_D >> AcG20ExGw.insertAbdocu_D");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_D abdocu_d >> " + abdocu_d.toString());
		return update("AcG20ExGw.insertAbdocu_D", abdocu_d);
	}

	/**
	 * deleteAbdocu_D doban7 2016. 10. 3.
	 * 
	 * @param abdocu_d
	 */
	public int deleteAbdocu_D(Abdocu_D abdocu_d) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_D >> AcG20ExGw.deleteAbdocu_D");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_D abdocu_d >> " + abdocu_d.toString());
		return delete("AcG20ExGw.deleteAbdocu_D", abdocu_d);
	}

	/**
	 * getItemsTotalAm doban7 2016. 10. 5.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public HashMap<String, String> getItemsTotalAm(Abdocu_H abdocu_H, String queryID) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getItemsTotalAm >> " + queryID);
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu_H >> " + abdocu_H.toString());
		return (HashMap<String, String>) selectByPk(queryID, abdocu_H);
	}

	/**
	 * getETCDUMMY1 doban7 2016. 10. 6.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, String> getETCDUMMY1(HashMap<String, String> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getETCDUMMY1 >> AcG20ExGw.getETCDUMMY1");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return (HashMap<String, String>) select("AcG20ExGw.getETCDUMMY1", paramMap);
	}

	/**
	 * setAbdocuCause doban7 2016. 10. 6.
	 * 
	 * @param abdocu
	 * @return
	 */
	public int updateAbdocuCause(Abdocu_H abdocu) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updateAbdocuCause >> AcG20ExGw.updateAbdocuCause");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H abdocu >> " + abdocu.toString());
		return update("AcG20ExGw.updateAbdocuCause", abdocu);
	}

	/**
	 * getPayDataList_Sub doban7 2016. 10. 21.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<PayDataVO> getThisPayDataList(HashMap<String, String> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getThisPayDataList >> AcG20ExGw.getThisPayDataList");
		LOG.debug("! [G20] AcG20ExGwDAO - Map<String, String> paramMap >> " + paramMap.toString());
		return list("AcG20ExGw.getThisPayDataList", paramMap);
	}

	/**
	 * deleteAbdocu_T_PayData doban7 2016. 10. 24.
	 * 
	 * @param payDataVO
	 */
	public int deleteAbdocu_T_PayData(PayDataVO payDataVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - deleteAbdocu_T_PayData >> AcG20ExGw.deleteAbdocu_T_PayData");
		LOG.debug("! [G20] AcG20ExGwDAO - PayDataVO payDataVO >> " + payDataVO.toString());
		return delete("AcG20ExGw.deleteAbdocu_T_PayData", payDataVO);

	}

	/**
	 * insertAbdocu_T_PayData doban7 2016. 10. 24.
	 * 
	 * @param payDataVO
	 * @return
	 */
	public String insertAbdocu_T_PayData(PayDataVO payDataVO) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertAbdocu_T_PayData >> AcG20ExGw.insertAbdocu_T_PayData");
		LOG.debug("! [G20] AcG20ExGwDAO - PayDataVO payDataVO >> " + payDataVO.toString());
		return (String) insert("AcG20ExGw.insertAbdocu_T_PayData", payDataVO);
	}

	/**
	 * insertPayData doban7 2016. 10. 24.
	 * 
	 * @param payDataVO
	 */
	public void insertPayData(PayDataVO payDataVO) {
		LOG.debug("! [G20] AcG20ExGwDAO - insertPayData >> AcG20ExGw.insertPayData");
		LOG.debug("! [G20] AcG20ExGwDAO - PayDataVO payDataVO >> " + payDataVO.toString());
		insert("AcG20ExGw.insertPayData", payDataVO);
	}

	/** 
	 * updateErpGwLink doban7 2016. 11. 13.
	 * @param linkMap
	 */
	public void updateErpGwLink(HashMap<String, String> paraMap) {
		update("AcG20ExGw.updateErpGwLink", paraMap); 
	}

	/** 
	 * chkGwAcExDoExist doban7 2016. 11. 13.
	 * @param abdocu_h
	 * @return
	 */
	public Integer chkGwAcExDoExist(Abdocu_H abdocu_h) {
		return (Integer) select("AcG20ExGw.chkGwAcExDoExist", abdocu_h);
	}
	
	/**
	 * insertPurcReq parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object insertPurcReq(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertPurcReq >> AcG20ExGw.insertPurcReq");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return insert("AcG20ExGw.insertPurcReq", paramMap);	
	}
	
	/**
	 * updatePurcReq parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object updatePurcReq(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updatePurcReq >> AcG20ExGw.updatePurcReq");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return insert("AcG20ExGw.updatePurcReq", paramMap);	
	}
	
	/**
	 * insertPurcReqH parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object insertPurcReqH(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertPurcReqH >> AcG20ExGw.insertPurcReqH");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return insert("AcG20ExGw.insertPurcReqH", paramMap);	
	}
	
	/**
	 * updatePurcReqH parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object updatePurcReqH(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updatePurcReqH >> AcG20ExGw.updatePurcReqH");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return update("AcG20ExGw.updatePurcReqH", paramMap);	
	}

	/**
	 * getPurcReq parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object getPurcReq(HashMap<String, Object> paramMap) throws Exception {
		return select("AcG20ExGw.getPurcReq", paramMap);
	}

	/**
	 * getPurcReqH parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object getPurcReqH(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcReqH(paramMap);
		}else{
			return list("AcG20ExGw.getPurcReqH", paramMap);
		}
	}

	/**
	 * insertPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object insertPurcReqB(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertPurcReqB >> AcG20ExGw.insertPurcReqB");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return insert("AcG20ExGw.insertPurcReqB", paramMap);			
	}

	/**
	 * updatePurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object updatePurcReqB(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updatePurcReqB >> AcG20ExGw.updatePurcReqB");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return update("AcG20ExGw.updatePurcReqB", paramMap);
	}
	
	/**
	 * delPurcReq_H parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	public int delPurcReq_H(Abdocu_H abdocu_H) throws Exception {
		return delete("AcG20ExGw.delPurcReq_H", abdocu_H);
	}
	
	/**
	 * delPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	public int delPurcReqB(Abdocu_B abdocu_B) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - delPurcReqB >> AcG20ExGw.delPurcReqB");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return delete("AcG20ExGw.delPurcReqB", abdocu_B);
	}
	
	/**
	 * 
	 * delPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	public int delPurcReqT(Abdocu_T abdocu_T) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - delPurcReqT >> AcG20ExGw.delPurcReqT");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_T abdocu_T >> " + abdocu_T.toString());
		return delete("AcG20ExGw.delPurcReqT", abdocu_T);
	}
	
	/**
	 * getPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_B> getPurcReqB(Abdocu_H abdocu_H) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getPurcReqB >> AcG20ExGw.getPurcReqB");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_H >> " + abdocu_H.toString());
		return list("AcG20ExGw.getPurcReqB", abdocu_H);
	}
	
	/**
	 * insertPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object insertPurcReqT(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - insertPurcReqT >> AcG20ExGw.insertPurcReqT");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return insert("AcG20ExGw.insertPurcReqT", paramMap);			
	}

	/**
	 * updatePurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object updatePurcReqT(HashMap<String, Object> paramMap) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - updatePurcReqT >> AcG20ExGw.updatePurcReqT");
		LOG.debug("! [G20] AcG20ExGwDAO - paramMap >> " + paramMap.toString());
		return update("AcG20ExGw.updatePurcReqT", paramMap);
	}
	
	/**
	 * getPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getPurcReqT(Abdocu_B abdocu_B) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getPurcReqT >> AcG20ExGw.getPurcReqT");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return list("AcG20ExGw.getPurcReqT", abdocu_B);
	}
	
	/**
	 * getPurcReqTList parkjm 2018. 4. 13.
	 * 
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getPurcReqTList(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcReqTList(paramMap);
		}else{
			return list("AcG20ExGw.getPurcReqTList", paramMap);
		}
	}

	/**
	 * setPurcReqAttach parkjm 2018. 3. 22.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object setPurcReqAttach(HashMap<String, Object> paramMap) throws Exception {
		return insert("AcG20ExGw.setPurcReqAttach", paramMap);
	}
	
	/**
	 * setPurcReqAttach parkjm 2018. 3. 22.
	 * 
	 * @param paramMap
	 * @return
	 */
	public Object setPurcContAttach(HashMap<String, Object> paramMap) throws Exception {
		return insert("AcG20ExGw.setPurcContAttach", paramMap);
	}

	public Object getAttachFileList(HashMap<String, Object> paramMap) throws Exception {
		return list("AcG20ExGw.getAttachFileList", paramMap);
	}
	
	public Object getAttachFileList2(HashMap<String, Object> paramMap) throws Exception {
		return list("AcG20ExGw.getAttachFileList2", paramMap);
	}

	public void makePurcReqNo(HashMap<String, Object> paramMap) throws Exception {
		update("AcG20ExGw.makePurcReqNo", paramMap);
	}

	public void updatePurcReqState(Map<String, Object> paramMap) throws Exception {
		update("AcG20ExGw.updatePurcReqState", paramMap);
	}

	public Object excelUploadSaveAbdocuT(Map<String, String> excelContent) throws Exception {
		return insert("AcG20ExGw.excelUploadSaveAbdocuT", excelContent);
	}

	public void excelUploadSavePurcReqT(Map<String, String> excelContent) throws Exception {
		insert("AcG20ExGw.excelUploadSavePurcReqT", excelContent);
	}

	public Object selectAbdocuB_ApplyAm(String abdocu_b_no) throws Exception {
		return select("AcG20ExGw.selectAbdocuB_ApplyAm", abdocu_b_no);
	}

	public Object purcReqListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.purcReqListData", map);
	}

	public Object purcReqListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.purcReqListDataTotal", map);
	}
	
	public Object purcContListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.purcContListData", map);
	}
	
	public Object purcContListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.purcContListDataTotal", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> selectAbdocuBNoList(String purcReqId) throws Exception {
		return list("AcG20ExGw.selectAbdocuBNoList", purcReqId);
	}
	
	/**
	 * 
	 * getReferConferPurcReq doban7 2016. 9. 29.
	 * 
	 * @param paramMap
	 * @param queryID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getReferConferPurcReq(HashMap<String, String> paramMap) {
		LOG.debug("! [G20] AcG20ExGwDAO - getReferConfer >> AcG20ExGw.getReferConferWithAuthPurcReq");
		return (List<HashMap<String, String>>) list("AcG20ExGw.getReferConferWithAuthPurcReq", paramMap);	
	}

	public Object makePurcCont(Map<String, String> paraMap) throws Exception {
		return insert("AcG20ExGw.makePurcCont",paraMap);
	}

	public void makePurcContB(Map<String, String> paraMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.makePurcContB(paraMap);
		}else{
			insert("AcG20ExGw.makePurcContB",paraMap);
		}
	}

	public void makePurcContT(Map<String, String> paraMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.makePurcContT(paraMap);
		}else{
			insert("AcG20ExGw.makePurcContT",paraMap);
		}
	}
	
	public void delMakePurcContB(Map<String, Object> paraMap) throws Exception {
		delete("AcG20ExGw.delMakePurcContB",paraMap);
	}

	public Object updatePurcCont(Map<String, String> paraMap) throws Exception {
		return update("AcG20ExGw.updatePurcCont", paraMap);
	}
	
	/**
	 * getPurcContB parkjm 2018. 4. 3.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_B> getPurcContB(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcContB(map);
		}else{
			return list("AcG20ExGw.getPurcContB", map);
		}
	}

	public Object purcContInfo(HashMap<String, Object> paramMap) throws Exception {
		return select("AcG20ExGw.purcContInfo", paramMap);
	}
	
	/**
	 * getPurcContT parkjm 2018. 4. 4.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Abdocu_T> getPurcContT(Abdocu_B abdocu_B) throws Exception {
		LOG.debug("! [G20] AcG20ExGwDAO - getPurcContT >> AcG20ExGw.getPurcContT");
		LOG.debug("! [G20] AcG20ExGwDAO - Abdocu_B abdocu_B >> " + abdocu_B.toString());
		return list("AcG20ExGw.getPurcContT", abdocu_B);
	}

	public Object updatePurcContT(Abdocu_T abdocu_T) throws Exception {
		return update("AcG20ExGw.updatePurcContT", abdocu_T);
	}

	public void updatePurcContB_ApplyAm(Abdocu_T abdocu_T) throws Exception {
		update("AcG20ExGw.updatePurcContB_ApplyAm", abdocu_T);
	}
	
	public void updatePurcContB_OpenAm(Abdocu_T abdocu_T) throws Exception {
		update("AcG20ExGw.updatePurcContB_OpenAm", abdocu_T);
	}
	
	public void updatePurcCont_contAm(Abdocu_T abdocu_T) throws Exception {
		update("AcG20ExGw.updatePurcCont_contAm", abdocu_T);
	}

	public Abdocu_B getpurcContB_One(String purc_cont_b_id) throws Exception {
		return (Abdocu_B)select("AcG20ExGw.getpurcContB_One", purc_cont_b_id);
	}

	public int delPurcContT(Abdocu_T abdocu_T) throws Exception {
		return delete("AcG20ExGw.delPurcContT", abdocu_T);
	}

	public void updatePurcReqB_ApplyAm(Abdocu_T abdocu_T) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.updatePurcReqB_ApplyAm( abdocu_T );
		}else{
			update("AcG20ExGw.updatePurcReqB_ApplyAm", abdocu_T);
		}
	}
	
	public Object getPurcReqLeftAm(Abdocu_T abdocu_T) throws Exception {
		return select("AcG20ExGw.getPurcReqLeftAm", abdocu_T);
	}

	public Object checkPurcContComplete(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.checkPurcContComplete", map);
	}
	
	public Object checkPurcContApproval(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.checkPurcContApproval", map);
	}

	public void resetAbdocuT(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.resetAbdocuT( map );
		}else{
			update("AcG20ExGw.resetAbdocuT", map);
		}
	}
	
	public void updateAbdocuT(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.updateAbdocuT( map );
		}else{
			update("AcG20ExGw.updateAbdocuT", map);
		}
	}
	
	public void updateAbdocuB_ApplyAm_purc(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.updateAbdocuB_ApplyAm_purc( map );
		}else{
			update("AcG20ExGw.updateAbdocuB_ApplyAm_purc", map);
		}
	}
	
	public void updateReqDocSts(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.updateReqDocSts", map);
	}
	
	public void updateContDocSts(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.updateContDocSts", map);
	}

	public Object checkPurcReqState(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.checkPurcReqState", map);
	}

	public int checkPurcContractedComplete(Map<String, Object> map) {
		return (int)select("AcG20ExGw.checkPurcContractedComplete", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> tempSaveFileList(HashMap<String, Object> requestMap) throws Exception {
		return list("AcG20ExGw.tempSaveFileList", requestMap);
	}

	public String makeContInspInfo(HashMap<String, Object> requestMap) throws Exception {
		return String.valueOf(insert("AcG20ExGw.makeContInspInfo", requestMap));
	}

	public void makeContInspTInfo(HashMap<String, Object> requestMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.makeContInspTInfo( requestMap );
		}else{
			insert("AcG20ExGw.makeContInspTInfo", requestMap);
		}
	}
	
	public void makeContInspTInfo2(HashMap<String, Object> requestMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.makeContInspTInfo2( requestMap );
		}else{
			insert("AcG20ExGw.makeContInspTInfo2", requestMap);
		}
	}

	public Object getContInsp(HashMap<String, Object> requestMap) throws Exception {
		return select("AcG20ExGw.getContInsp", requestMap);
	}

	public Object getContInspT(HashMap<String, Object> requestMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getContInspT( requestMap );
		}else{
			return list("AcG20ExGw.getContInspT", requestMap);
		}
	}

	public int updatePurcContInsp(HashMap<String, Object> requestMap) throws Exception {
		return update("AcG20ExGw.updatePurcContInsp", requestMap);
	}
	
	public int updatePurcContInspT(HashMap<String, Object> requestMap) throws Exception {
		return update("AcG20ExGw.updatePurcContInspT", requestMap);
	}

	public void updatePurcReqContent(HashMap<String, Object> requestMap) throws Exception {
		update("AcG20ExGw.updatePurcReqContent", requestMap);
	}
	
	public void makeContentsStr(HashMap<String, Object> requestMap) throws Exception {
		insert("AcG20ExGw.makeContentsStr", requestMap);
	}

	public Object getPurcReqHBList(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcReqHBList( paramMap );
		}else{
			return list("AcG20ExGw.getPurcReqHBList", paramMap);
		}
	}
	
	public Object getPurcContHBList(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcContHBList( paramMap );
		}else{
			return list("AcG20ExGw.getPurcContHBList", paramMap);
		}
	}
	
	public Object getPurcContTList(HashMap<String, Object> paramMap) throws Exception {
		return list("AcG20ExGw.getPurcContTList", paramMap);
	}

	public void updatePurcContContent(HashMap<String, Object> requestMap) throws Exception {
		update("AcG20ExGw.updatePurcContContent", requestMap);
	}

	public Object purcContInspListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.purcContInspListData", map);
	}

	public Object purcContInspListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.purcContInspListDataTotal", map);
	}

	public Object inspTopBoxInit(HashMap<String, Object> requestMap) throws Exception {
		return select("AcG20ExGw.inspTopBoxInit",requestMap);
	}

	public void updatePurcReqContAm(HashMap<String, Object> requestMap) throws Exception {
		update("AcG20ExGw.updatePurcReqContAm", requestMap);
	}

	public Object selectPurcReqContAm(HashMap<String, Object> requestMap) throws Exception {
		return select("AcG20ExGw.selectPurcReqContAm", requestMap);
	}

	public void makeContInfoUpdate(Map<String, String> map) throws Exception {
		update("AcG20ExGw.makeContInfoUpdate", map);
	}

	public void updatePurcContInspContent(HashMap<String, Object> requestMap) throws Exception {
		update("AcG20ExGw.updatePurcContInspContent", requestMap);
	}

	public Object checkInspComplete(HashMap<String, Object> requestMap) throws Exception {
		return select("AcG20ExGw.checkInspComplete", requestMap);
	}

	public Object purcContModListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.purcContModListData", map);
	}

	public Object purcContModListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.purcContModListDataTotal", map);
	}

	public String makeContModInfo(HashMap<String, Object> requestMap) throws Exception {
		return (String)insert("AcG20ExGw.makeContModInfo", requestMap);
	}

	public void makeContModBInfo(HashMap<String, Object> requestMap) throws Exception {
		insert("AcG20ExGw.makeContModBInfo", requestMap);
	}
	
	public void makeContModTInfo(HashMap<String, Object> requestMap) throws Exception {
		insert("AcG20ExGw.makeContModTInfo", requestMap);
	}

	public void makeContModAttachFile(HashMap<String, Object> requestMap) throws Exception {
		insert("AcG20ExGw.makeContModAttachFile", requestMap);
	}

	public void updatePurcContMod(HashMap<String, Object> requestMap) throws Exception {
		update("AcG20ExGw.updatePurcContMod", requestMap);
	}

	public Object getApplyAm(HashMap<String, Object> paramMap) throws Exception {
		return select("AcG20ExGw.getApplyAm", paramMap);
	}

	public Object getAceptAm(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getAceptAm( paramMap );
		}else{
			return select("AcG20ExGw.getAceptAm", paramMap);
		}
	}

	public void resetAbdocuTMod(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.resetAbdocuTMod( paramMap );
		}else{
			update("AcG20ExGw.resetAbdocuTMod", paramMap);
		}
	}

	public void updateAbdocuTMod(HashMap<String, Object> paramMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			acG20Ex2GwDAO.updateAbdocuTMod( paramMap );
		}else{
			update("AcG20ExGw.updateAbdocuTMod", paramMap);
		}
	}

	public void completePurcContMod(HashMap<String, Object> paramMap) throws Exception {
		update("AcG20ExGw.completePurcContMod", paramMap);
	}
	
	public void requestPurcContMod(HashMap<String, Object> paramMap) throws Exception {
		update("AcG20ExGw.requestPurcContMod", paramMap);
	}

	public Object purcContPayListData(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.purcContPayListData( map );
		}else{
			return list("AcG20ExGw.purcContPayListData", map);
		}
	}

	public Object purcContPayListDataTotal(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.purcContPayListDataTotal( map );
		}else{
			return select("AcG20ExGw.purcContPayListDataTotal", map);
		}
	}

	public Object getTemplateKey(HashMap<String, Object> paramMap) throws Exception {
		return select("AcG20ExGw.getTemplateKey", paramMap);
	}

	public Object getPurcContPjtList(HashMap<String, Object> paramMap) throws Exception {
		return list("AcG20ExGw.getPurcContPjtList", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Abdocu_B> selectPurcContPay_B(Abdocu_B abdocu_B) throws Exception {
		return list("AcG20ExGw.selectPurcContPay_B", abdocu_B);
	}

	@SuppressWarnings("unchecked")
	public List<Abdocu_T> selectPurcContPay_T(Abdocu_B t_abdocu_B) throws Exception {
		return list("AcG20ExGw.selectPurcContPay_T2", t_abdocu_B);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getPurcContPayParam(Abdocu_H abdocu_H_Tmp) throws Exception {
		return (Map<String, Object>)select("AcG20ExGw.getPurcContPayParam", abdocu_H_Tmp);
	}

	public void updateContPayTradeInfo(HashMap<String, String> tradeInfo) throws Exception {
		update("AcG20ExGw.updateContPayTradeInfo", tradeInfo);
	}

	public String insertPurcContPay(Map<String, Object> contPayParam) throws Exception {
		return (String)insert("AcG20ExGw.insertPurcContPay", contPayParam);
	}

	public String insertPurcContPayB(Map<String, Object> contPayParam) throws Exception {
		return (String)insert("AcG20ExGw.insertPurcContPayB", contPayParam);
	}
	
	public String insertPurcContPayT(Map<String, Object> contPayParam) throws Exception {
		return (String)insert("AcG20ExGw.insertPurcContPayT", contPayParam);
	}

	public void updatePurcContPay(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.updatePurcContPay", map);
	}

	public Object getPurcContPay(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.getPurcContPay", map);
	}

	public void purcContPayComplete(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.purcContPayComplete", map);
	}

	public int checkPurcContPayComplete(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return (int)acG20Ex2GwDAO.checkPurcContPayComplete(map);
		}else{
			return (int)select("AcG20ExGw.checkPurcContPayComplete", map);
		}
	}

	public void updatePurcContPayContent(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.updatePurcContPayContent", map);
	}

	public Object getContPay(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.getContPay", map);
	}

	public Object getAbdocuH(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.getAbdocuH", map);
	}

	public Object getAbdocuB(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.getAbdocuB", map);
	}

	public Object getAbdocuT(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.getAbdocuT", map);
	}

	public Object purcItemListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.purcItemListData", map);
	}

	public Object purcItemListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.purcItemListDataTotal", map);
	}
	
	public List<proposalVO> proposalEvaluationList() throws Exception{
		return (List<proposalVO>) list("AcG20ExGw.proposalEval");
	}

	public void updateItemType(Map<String, Object> map) throws Exception {
		update("AcG20ExGw.updateItemType", map);
	}

	public Object getContPopupListData(Map<String, Object> map) throws Exception {
		return list("AcG20ExGw.getContPopupListData", map);
	}

	public Object getContPopupListDataTotal(Map<String, Object> map) throws Exception {
		return select("AcG20ExGw.getContPopupListDataTotal", map);
	}

	public String getPurcReqBNextAm(Abdocu_T abdocu_T) throws Exception {
		return  (String)select("AcG20ExGw.getPurcReqBNextAm", abdocu_T);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getRefDoc(Map<String, String> paraMap) throws Exception {
		return list("AcG20ExGw.getRefDoc", paraMap);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getBgtBottomDetp() throws Exception {
		return list("AcG20ExGw.getBgtBottomDetp", null);
	}

	public void updatePurcCont_basicAm(Abdocu_T abdocu_T) throws Exception {
		update("AcG20ExGw.updatePurcCont_basicAm", abdocu_T);
	}

	public void updatePurcReqRequester(Map<String, String> paraMap) {
		update("AcG20ExGw.updatePurcReqRequester", paraMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getMainGrid(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return list("AcG20Ex2Gw.getMainGrid", map);
		}else{
			return list("AcG20ExGw.getMainGrid", map);
		}
	}
	
	public int getMainGridTotal(Map<String, Object> map) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return (Integer)select("AcG20Ex2Gw.getMainGridTotal", map);
		}else{
			return (Integer)select("AcG20ExGw.getMainGridTotal", map);
		}
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

	public void updateContTrInfo(Map<String, Object> map) {
		update("AcG20ExGw.updateContTrInfo", map);
	}

	public void insertAddTr(Map<String, Object> map) {
		insert("AcG20ExGw.insertAddTr", map);
	}

	public void deleteAddTr(Map<String, Object> map) {
		delete("AcG20ExGw.deleteAddTr", map);
	}

	public Object getPurcContAddTr(HashMap<String, Object> paramMap) {
		return list("AcG20ExGw.purcContAddTr", paramMap);
	}

	public void makeContModAddTr(HashMap<String, Object> requestMap) {
		insert("AcG20ExGw.makeContModAddTr", requestMap);
	}

	public Object getPurcContIdOrg(Map<String, Object> requestMap) {
		return select("AcG20ExGw.getPurcContIdOrg", requestMap);
	}

	public void completePurcContModB(HashMap<String, Object> paramMap) {
		update("AcG20ExGw.completePurcContModB", paramMap);
	}

	public void completePurcContModT(HashMap<String, Object> paramMap) {
		update("AcG20ExGw.completePurcContModT", paramMap);
	}

	public int proposalEvaluationListTotal() {
		return (int) select("AcG20ExGw.proposalEvalTotal");
	}

}

