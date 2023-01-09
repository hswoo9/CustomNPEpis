package ac.g20.cms.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @title PayCmsG20DAO.java
 * @author 권현태
 *
 * @date 2018. 5. 25.
 */
@Repository("PayCmsG20DAO")
public class PayCmsG20DAO {

	/* 변수정의 */
	private SqlSessionFactory sqlSessionFactory;

	@Resource ( name = "AcCommonService" )
	AcCommonService acCommonService;
	
	/* 변수정의 - 로그 */
	private org.apache.logging.log4j.Logger	LOG	= LogManager.getLogger(this.getClass());

	/* 공통사용 */
	/* 공통사용 - 커넥션 */
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장 / String resource = "sample/mybatis/sql/mybatis-config.xml";
			//			String resource = "egovframework/sqlmap/config/" + conVo.getDatabaseType() + "/ex/ex-mybatis-config.xml";
			String resource = "config/mybatis/context-mapper-g20-config.xml";

			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver", conVo.getDriver());
			props.put("url", conVo.getUrl());
			props.put("username", conVo.getUserId());
			props.put("password", conVo.getPassWord());
			props.put("erpTypeCode", conVo.getSystemType());
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성 / sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			} else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}
			result = true;
		}
		catch (Exception e) {
			System.out.println("세션 팩토리 생성 실패:" + e.getMessage());
		}

		return result;
	}

	/**
	 * list doban7 2016. 9. 5.
	 * 
	 * @param queryID
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private List<HashMap<String, String>> list(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {

		LOG.debug("+ [G20] AcG20ExErpDAO - list");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, String>> result = null;
		try {
			result = session.selectList(queryID, paraMap);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		finally {
			session.close();
		}

		LOG.debug("- [G20] AcG20ExErpDAO - list");

		return result;
	}

	public List<HashMap<String, String>> payCmsList(Map<String, String> paraMap) throws Exception {
		
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return list("payCms.payCmsList",conVo,paraMap);
	}
	
	/**
	 * GetConnection doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private ConnectionVO GetConnection ( ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>( );
		param.put( "loginVO", loginVO );
		return acCommonService.acErpSystemInfo( param );
	}

	public List<HashMap<String, String>> paySctrlD(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return list("payCms.paySctrlD",conVo,paraMap);
	}

	public List<HashMap<String, String>> tkpPayCd(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return list("payCms.tkpPayCd",conVo,paraMap);
	}

	public List<HashMap<String, String>>  tkpPayYm(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return list("payCms.tkpPayYm",conVo,paraMap);
	}
	
}
