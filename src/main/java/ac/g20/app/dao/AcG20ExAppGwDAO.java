package ac.g20.app.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_TH;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * @title AcG20ExAppGwDAO.java
 * @author doban7
 *
 * @date 2016. 9. 5. 
 */
@Repository("AcG20ExAppGwDAO")
public class AcG20ExAppGwDAO extends EgovComAbstractDAO{

	/** 
	 * completeApproval doban7 2016. 9. 26.
	 * @param abdocu_Tmp
	 * @return
	 * @throws Exception 
	 */
	public int completeApproval(Abdocu_H abdocu_Tmp) throws Exception {
        if(abdocu_Tmp.getC_dikeycode() == null || abdocu_Tmp.getC_dikeycode().isEmpty()){
        	throw new Exception("문서키코드(C_DIKEYCODE)가 없습니다.");
        }

        if(abdocu_Tmp.getAbdocu_no() == null || abdocu_Tmp.getAbdocu_no().isEmpty()){
        	throw new Exception("abdocu_no가 없습니다.");
        }
        int result = update("AcG20ExAppGw.APPROVAL-COMPLETE-Abdocu_H", abdocu_Tmp);
        if(result == 0){ 
        	throw new Exception("문서키코드(C_DIKEYCODE)를 저장하지 못하였습니다.");
        }
        return result;
	}

	/** 
	 * completeERPData doban7 2016. 9. 26.
	 * @param abdocu_Tmp
	 */
	public int completeERPAbdocuHData(Abdocu_H abdocu_Tmp) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_H", abdocu_Tmp);
		
	}

	/** 
	 * completeERPDataMerge doban7 2016. 9. 26.
	 * @param string
	 */
	public int completeERPDataAbdocuBMerge(String tempSql) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_B_MERGE", tempSql);
		
	}

	/** 
	 * completeERPDataAbdocuTMerge doban7 2016. 9. 26.
	 * @param string
	 */
	public int completeERPDataAbdocuTMerge(String abdocuTTmpSql) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_T_MERGE", abdocuTTmpSql) ;
		
	}

	/** 
	 * completeERPData doban7 2016. 9. 26.
	 * @param insertAbdocu_TH_Tmp
	 */
	public int completeERPAbdocuTHData(Abdocu_TH insertAbdocu_TH_Tmp) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_TH", insertAbdocu_TH_Tmp);
		
	}

	/**
	 * 
	 * completeERPDataAbdocuTDMerge doban7 2016. 10. 5.
	 * @param abdocuTTmpSql
	 * @return
	 * @throws Exception
	 */
	public int completeERPDataAbdocuTDMerge(String abdocuTDTmpSql) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_TD_MERGE", abdocuTDTmpSql) ;
		
	}
	
	/**
	 * 
	 * completeERPDataAbdocuTD2Merge doban7 2016. 10. 5.
	 * @param abdocuTD2TmpSql
	 * @return
	 * @throws Exception
	 */
	public int completeERPDataAbdocuTD2Merge(String abdocuTD2TmpSql) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_TD2_MERGE", abdocuTD2TmpSql) ;
		
	}
	
	/**
	 * 
	 * completeERPDataAbdocuDMerge doban7 2016. 10. 5.
	 * @param abdocuDTmpSql
	 * @return
	 * @throws Exception
	 */
	public int completeERPDataAbdocuDMerge(String abdocuDTmpSql) throws Exception{
		return update("AcG20ExAppGw.ERP-COMPLETE-Abdocu_D_MERGE", abdocuDTmpSql) ;
		
	}

	/** 
	 * getAbDocuH doban7 2016. 10. 17.
	 * @param param
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public Map<String, Object> getAppAbDocuH(Map<String, Object> param) {
		return (Map<String, Object>) selectByPk("AcG20ExAppGw.getAppAbDocuH", param);
	}

	/** 
	 * getReferDocInfo doban7 2016. 10. 17.
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAppReferDocInfo(Map<String, Object> param) {
		return list("AcG20ExAppGw.getAppReferDocInfo", param);
	}

	/** 
	 * getAbDocuB_List doban7 2016. 10. 17.
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAppAbDocuB_List(Map<String, Object> param) {
		return list("AcG20ExAppGw.getAppAbDocuB_List", param);
	}

	/** 
	 * getAbDocuT_List doban7 2016. 10. 17.
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAppAbDocuT_List(Map<String, Object> param) {
		return list("AcG20ExAppGw.getAppAbDocuT_List", param);
	}

	/** 
	 * getAppAbDocuD_List doban7 2016. 10. 18.
	 * @param abdocu_no
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> getAppAbDocuD_List(String abdocu_no) {
		return list("AcG20ExAppGw.getAppAbDocuD_List", abdocu_no);
	}

	/** 
	 * getAppAbDocuTD2_List doban7 2016. 10. 18.
	 * @param abdocu_no
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> getAppAbDocuTD2_List(String abdocu_no) {
		return list("AcG20ExAppGw.getAppAbDocuTD2_List", abdocu_no);
	}

}

