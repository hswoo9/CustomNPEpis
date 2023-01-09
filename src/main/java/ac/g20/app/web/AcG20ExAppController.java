package ac.g20.app.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Controller;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @title ExiCubeManageController.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */

@Controller
public class AcG20ExAppController {

	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(AcG20ExAppController.class);
	
	@Resource(name ="AcCommonService")
	AcCommonService acCommonService;

	
	private ConnectionVO conVo	= new ConnectionVO();
	
	/** 
	 * GetConnection doban7 2016. 9. 1.
	 * @return
	 */
	private ConnectionVO GetConnection() throws Exception{
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		return acCommonService.acErpSystemInfo(param);
	}
		
	

}
