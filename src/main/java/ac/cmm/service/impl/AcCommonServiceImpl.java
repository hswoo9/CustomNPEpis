package ac.cmm.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import ac.cmm.dao.AcCommonDAO;
import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;


/**
 * @title AcCommonService.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
@Service("AcCommonService")
public class AcCommonServiceImpl implements AcCommonService {

	@Resource(name = "AcCommonDAO")
	private AcCommonDAO	acCommonDAO;
	
	@Value("#{bizboxa['BizboxA.msSql.DbType']}")
	private String dbType;
	
	@Value("#{bizboxa['BizboxA.ErpType']}")
	private String erpType;
	
	@Value("#{bizboxa['BizboxA.msSql.DriverClassName']}")
	private String dbDriver;
	
	@Value("#{bizboxa['BizboxA.msSql.Url']}")
	private String dbUrl;
	
	@Value("#{bizboxa['BizboxA.msSql.UserName']}")
	private String dbUser;
	
	@Value("#{bizboxa['BizboxA.msSql.Password']}")
	private String dbPass;
	
	/** 
	 * doban7 2016. 9. 1. 
	 * acErpSystemInfo
	 **/
	@Override
	public ConnectionVO acErpSystemInfo(Map<String, Object> param) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		ConnectionVO connectionVo = new ConnectionVO();

		try {

			result = acCommonDAO.acErpSystemInfo(param);

			if (result == null || result.size() < 1) {
				// ERP 연동이 없는 경우 데이터가 없을 수 있음.
				/*connectionVo.setDatabaseType(BizboxAProperties.getProperty("BizboxA.DbType"));
				connectionVo.setDriver(BizboxAProperties.getProperty("BizboxA.DriverClassName"));
				connectionVo.setUrl(BizboxAProperties.getProperty("BizboxA.Url"));
				connectionVo.setUserId(BizboxAProperties.getProperty("BizboxA.UserName"));
				connectionVo.setPassWord(BizboxAProperties.getProperty("BizboxA.Password"));
				connectionVo.setSystemType("BizboxA");*/
			} else {
				/*connectionVo.setDatabaseType(dbType);
				connectionVo.setDriver(dbDriver);
				connectionVo.setUrl(dbUrl);
				connectionVo.setUserId(dbUser);
				connectionVo.setPassWord(dbPass);
				connectionVo.setSystemType(erpType);
				
				System.out.println("ERP DB타입 : "+dbType+"  ||  ERP드라이버 : "+dbDriver+"  ||  ERP타입 : "+erpType+"  ||  ERP아이피 : "+dbUrl+"  ||  ERP아이디 : "+dbUser+"  ||  ERP비밀번호 : "+dbPass);*/
				
				connectionVo.setDatabaseType((String) result.get("DATABASE_TYPE"));
				connectionVo.setDriver((String) result.get("DRIVER"));
				connectionVo.setUrl((String) result.get("URL"));
				connectionVo.setUserId((String) result.get("USERID"));
				connectionVo.setPassWord((String) result.get("PASSWORD"));
				connectionVo.setSystemType((String) result.get("ERPTYPECODE"));
			}
		}
		catch (Exception e) {
			e.printStackTrace();
//			System.out.println(e.getMessage());

			throw e;
		}

//		System.out.println(" Erp 타입  : " + connectionVo.getSystemType());
		return connectionVo;
	}

}
