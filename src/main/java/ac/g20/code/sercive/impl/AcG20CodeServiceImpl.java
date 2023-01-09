
package ac.g20.code.sercive.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import ac.cmm.vo.ConnectionVO;
import ac.g20.code.dao.AcG20CodeErpDAO;
import ac.g20.code.sercive.AcG20CodeService;
import ac.g20.ex.dao.AcG20ExGwDAO;

/**
 * @title AcG20ExServiceImpl.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */

@Service("AcG20CodeService")
public class AcG20CodeServiceImpl implements AcG20CodeService {

	@Resource(name = "AcG20CodeErpDAO")
	private AcG20CodeErpDAO	acG20CodeErpDAO;
	@Resource ( name = "AcG20ExGwDAO" )
	private AcG20ExGwDAO acG20ExGwDAO;
	/** 
	 * doban7 2016. 9. 2. 
	 * getErpConfig
	 **/
	@Override
	public List<HashMap<String, String>> getErpConfigList(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception{
        return acG20CodeErpDAO.getErpConfigList(paraMap, conVo);
	}
	
	/** 
	 * doban7 2016. 9. 1. 
	 * getErpUserInfo
	 **/
	@Override
	public Map<String, Object> getErpUserInfo(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception{
		
        Map<String, Object> map = new HashMap<String, Object>();
        HashMap<String, String> erpuser = acG20CodeErpDAO.getErpUser(paraMap, conVo);
        List<HashMap<String, Object>> erpgisu = acG20CodeErpDAO.getErpGISU(paraMap, conVo);
        map.put("erpuser", erpuser);
        map.put("erpgisu", erpgisu);

        return map;
	}

	/** 
	 * doban7 2016. 9. 5. 
	 * getErpDIVList
	 **/
	@Override
	public List<HashMap<String, String>> getErpDIVList(ConnectionVO conVo,HashMap<String, String> paraMap) throws Exception{
		return acG20CodeErpDAO.getErpDIVList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 5. 
	 * getErpUserList
	 **/
	@Override
	public List<HashMap<String, String>> getErpUserList(ConnectionVO conVo, HashMap<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpUserList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 5. 
	 * getErpMgtPjtList
	 **/
	@Override
	public List<HashMap<String, String>> getErpMgtPjtList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception {
		return acG20CodeErpDAO.getErpMgtPjtList(paraMap, conVo);
	} 
	
	/** 
	 * doban7 2016. 9. 5. 
	 * getErpMgtDeptList
	 **/
	@Override
	public List<HashMap<String, String>> getErpMgtDeptList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception {
		return acG20CodeErpDAO.getErpMgtDeptList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 5. 
	 * getErpAbgtBottomList
	 **/
	@Override
	public List<HashMap<String, String>> getErpAbgtBottomList(ConnectionVO conVo, Map<String, String> paraMap) throws Exception {
		List<HashMap<String, String>> deptList = acG20ExGwDAO.getBgtBottomDetp();
		List<HashMap<String, String>> resultList = acG20CodeErpDAO.getErpAbgtBottomList(paraMap, conVo);
		for (HashMap<String, String> bottom : resultList) {
			for (HashMap<String, String> dept : deptList) {
				if(bottom.get("BOTTOM_CD") != null && bottom.get("BOTTOM_CD").equals(dept.get("BOTTOM_CD"))) {
					bottom.put("DEPT_NAME", dept.get("DEPT_NAME"));
				}
			}
		}
		return resultList;
	}

	/** 
	 * doban7 2016. 9. 5. 
	 * getErpBTRList
	 **/
	@Override
	public List<HashMap<String, String>> getErpBTRList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpBTRList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 7. 
	 * getErpBudgetList
	 **/
	@Override
	public List<HashMap<String, String>> getErpBudgetList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpBudgetList(paraMap, conVo);
	}

	/** 
	 * asdlkjsb 2016. 9. 7. 
	 * getErpBudgetNameList
	 **/
	@Override
	public List<HashMap<String, String>> getErpBudgetNameList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpBudgetNameList(paraMap, conVo);
	}

	
	/** 
	 * doban7 2016. 9. 7. 
	 * getErpTradeList
	 **/
	@Override
	public List<HashMap<String, String>> getErpTradeList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
	}
	
	/** 
	 * getErpEmpBankTrade
	 **/
	@Override
	public List<HashMap<String, String>> getErpEmpBankTrade(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpEmpBankTrade(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 22. 
	 * getErpBankList
	 **/
	@Override
	public List<HashMap<String, String>> getErpBankList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpBankList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 22. 
	 * getErpEmpList
	 **/
	@Override
	public List<HashMap<String, String>> getErpEmpList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpEmpList(paraMap, conVo);
	}

	/** 
	 * doban7 2016. 9. 26. 
	 * getErpSempList
	 **/
	@Override
	public List<HashMap<String, String>> getErpHpmeticList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		List<HashMap<String, String>> temp = acG20CodeErpDAO.getErpHpmeticList(paraMap, conVo);
		for(HashMap<String, String> item : temp){
			String tString = item.get( "REG_NO" ).toString( );
			if(tString != null){
				if(tString.length( ) > 12){
					tString = tString.substring( 0, 6 ) + "-*******";
				}
			}
			item.put( "REG_NO", tString );
		}
		return temp;
	}
	
	/**
	 * doban7 2016. 9. 26. 
	 * getErpHincomeList
	 */
	@Override
	public List<HashMap<String, String>> getErpHincomeList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		List<HashMap<String, String>> temp = acG20CodeErpDAO.getErpHincomeList(paraMap, conVo);
		for(HashMap<String, String> item : temp){
			String tString = item.get( "REG_NO" ).toString( );
			if(tString != null){
				if(tString.length( ) > 12){
					tString = tString.substring( 0, 6 ) + "-*******";
				}
			}
			item.put( "REG_NO", tString );
		}
		return temp;
	}

	/** 
	 * doban7 2016. 10. 6. 
	 * getErpEtcIncomeList
	 **/
	@Override
	public List<HashMap<String, String>> getErpEtcIncomeList(ConnectionVO conVo, Map<String, String> paraMap)
			throws Exception {
		return acG20CodeErpDAO.getErpEtcIncomeList(paraMap, conVo);
	}

}
