package ac.cmm.dao;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Repository;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * @title AcCommonDAO.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
@Repository("AcCommonDAO")
public class AcCommonDAO extends EgovComAbstractDAO{

	/** 
	 * getExUtilSystemType doban7 2016. 9. 1.
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> acErpSystemInfo(Map<String, Object> param) {
		HttpServletRequest servletRequest = ((ServletRequestAttributes) RequestContextHolder .getRequestAttributes()).getRequest();
		if(servletRequest.getServerName().contains("localhost") || servletRequest.getServerName().contains("127.0.0.1")) {
			return (Map<String, Object>) select("AcCommonDAO.acErpSystemInfoTest", param);
		}else{
			return (Map<String, Object>) select("AcCommonDAO.acErpSystemInfo", param);
		}
	}

}
