package ac.g20.code.sercive;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ac.cmm.vo.ConnectionVO;

/**
 * @title AcG20CodeSercive.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
public interface AcG20CodeService {

	/** 
	 * getErpConfig doban7 2016. 9. 2.
	 * @param conVo
	 * @param paraMap
	 * @return
	 * @throws Exception 
	 */
	List<HashMap<String, String>> getErpConfigList(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception;
	
	/** 
	 * getErpUserInfo doban7 2016. 9. 1.
	 * @param conVo 
	 * @param paraMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getErpUserInfo(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception;


	/** 
	 * getErpDIVList doban7 2016. 9. 5.
	 * @param conVo 
	 * @param paraMap
	 * @return
	 * @throws Exception 
	 */
	List<HashMap<String, String>> getErpDIVList(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception;

	/** 
	 * getErpUserList doban7 2016. 9. 5.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpUserList(ConnectionVO conVo, HashMap<String, String> paraMap)throws Exception;

	/** 
	 * getErpMgtDeptList doban7 2016. 9. 5.
	 * @param conVo 
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpMgtDeptList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * getErpMgtPjtList doban7 2016. 9. 5.
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpMgtPjtList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;
	/** 
	 * getErpAbgtBottomList doban7 2016. 9. 5.
	 * @param conVo
	 * @param paraMap
	 * @return
	 * @throws Exception 
	 */
	List<HashMap<String, String>> getErpAbgtBottomList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;

	/** 
	 * getErpBTRList doban7 2016. 9. 5.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpBTRList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * getErpBudgetList doban7 2016. 9. 7.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpBudgetList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;

	/** 
	 * getErpBudgetNameList asdlkjsb 2017. 07. 07.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpBudgetNameList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;
	
	/** 
	 * getErpTradeList doban7 2016. 9. 7.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpTradeList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;
	
	/** 
	 * getErpEmpBankTrade 
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpEmpBankTrade(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;

	/** 
	 * getErpBankList doban7 2016. 9. 22.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpBankList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;

	/** 
	 * getErpEmpList doban7 2016. 9. 22.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpEmpList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * getErpSempList doban7 2016. 9. 26.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpHpmeticList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * getErpHincomeList doban7 2016. 9. 26.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpHincomeList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * getErpEtcIncomeList doban7 2016. 10. 6.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getErpEtcIncomeList(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

}
