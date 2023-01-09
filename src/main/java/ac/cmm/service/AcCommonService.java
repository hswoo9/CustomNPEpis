package ac.cmm.service;

import java.util.Map;

import ac.cmm.vo.ConnectionVO;

/**
 * @title AcCommonService.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
public interface AcCommonService {

	/** 
	 * acErpSystemTypeInfo doban7 2016. 9. 1.
	 * @param param
	 * @return
	 * @throws Exception 
	 */
	ConnectionVO acErpSystemInfo(Map<String, Object> param) throws Exception;

}
