/**
 * 
 */
package ac.g20.app.service;

import java.sql.SQLException;
import java.util.Map;

import ac.g20.ex.vo.Abdocu_H;

/**
 * @title AcExiCubeService.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
public interface AcG20ExAppService {

	/** 
	 * docG20Approval doban7 2016. 9. 28.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> docG20Approval(Map<String, Object> paramMap)throws Exception;

	/** 
	 * docG20MultiApproval doban7 2016. 10. 5.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> docG20MultiApproval(Map<String, Object> paramMap)throws Exception;
	
	/** 
	 * docG20ItemDetail doban7 2016. 10. 5.
	 * @param abDocuNo
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> docG20ItemDetail(String abDocuNo) throws Exception;
	
	/** 
	 * completeApproval doban7 2016. 9. 26.
	 * @param abdocu_Tmp
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> completeApproval(Abdocu_H abdocu_Tmp) throws Exception;

	/** 
	 * insertG20Data doban7 2016. 9. 26.
	 * @param abdocu_Tmp
	 * @return
	 * @throws SQLException
	 * @throws Exception
	 */
	Map<String, Object> insertG20Data(Abdocu_H abdocu_Tmp) throws SQLException, Exception;

	/** 
	 * approvalReturn doban7 2016. 9. 26.
	 * @param abdocuH
	 * @return 
	 */
	Map<String, Object> approvalReturn(Abdocu_H abdocuH) throws Exception;

	/** 
	 * approvalEnd doban7 2016. 9. 26.
	 * @param abdocu
	 * @return
	 */
	Map<String, Object> approvalEnd(Abdocu_H abdocu)throws Exception;


//	/** 
//	 * getErpPermission doban7 2016. 9. 21.
//	 * @param conVo
//	 * @param paraMap
//	 * @return
//	 */
//	HashMap<String, String> getErpPermission(ConnectionVO conVo, HashMap<String, String> paraMap);

}
