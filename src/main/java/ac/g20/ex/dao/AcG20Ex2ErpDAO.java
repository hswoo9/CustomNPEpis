/**
 * 
 */
package ac.g20.ex.dao;

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
import ac.g20.ex.vo.Abdocu_H;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @title AcG20Ex2ErpDAO.java
 * @author doban7
 *
 * @date 2016. 9. 5.
 */
@Repository("AcG20Ex2ErpDAO")
public class AcG20Ex2ErpDAO {

	@Resource ( name = "AcCommonService" )
	AcCommonService acCommonService;
	
	/* 변수정의 */
	private SqlSessionFactory				sqlSessionFactory;

	/* 변수정의 - 로그 */
	private org.apache.logging.log4j.Logger	LOG	= LogManager.getLogger(this.getClass());

	/* 공통사용 */
	/* 공통사용 - 커넥션 */
	private boolean connect() {
		boolean result = false;
		try {
			ConnectionVO conVo = GetConnection();
			// 환경 설정 파일의 경로를 문자열로 저장 / String resource = "sample/mybatis/sql/mybatis-config.xml";
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

	/**
	 * list doban7 2016. 9. 5.
	 * 
	 * @param queryID
	 * @param conVo
	 * @param param
	 * @return
	 */
	@SuppressWarnings("unused")
	private List<Map<String, Object>> list(String queryID, Object param) {

		LOG.debug("+ [G20] AcG20Ex2ErpDAO - list");
		LOG.debug("! [G20] String queryID >> " + queryID);

		connect();
		SqlSession session = sqlSessionFactory.openSession();
		List<Map<String, Object>> result = null;
		try {
			result = session.selectList(queryID, param);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		finally {
			session.close();
		}

		LOG.debug("- [G20] AcG20Ex2ErpDAO - list");

		return result;
	}

	/**
	 * select doban7 2016. 9. 5.
	 * 
	 * @param string
	 * @param conVo
	 * @param param
	 * @return
	 */
	private Map<String, Object> select(String queryID, Object param) {

		LOG.debug("+ [G20] AcG20Ex2ErpDAO - select");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Object param >> " + param.toString());

		connect();
		SqlSession session = sqlSessionFactory.openSession();
		Map<String, Object> result = null;
		try {
			result = session.selectOne(queryID, param);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		finally {
			session.close();
		}

		String resultString = "";
		if(result == null){
			resultString = "result is null.";
		}else{
			resultString  = result.toString( );
		}
		
		LOG.debug("! [G20] Map<String, Object> result >> " + resultString);
		LOG.debug("- [G20] AcG20Ex2ErpDAO - select");

		return result;
	}

	/**
	 * 
	 * insert doban7 2016. 9. 26.
	 * 
	 * @param queryID
	 * @param param
	 * @param conVo
	 * @return
	 */
	public Map<String, Object> insert(String queryID, Map<String, Object> param) {

		LOG.debug("+ [G20] AcG20Ex2ErpDAO - insert");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Object param >> " + param.toString());

		Map<String, Object> result = null;
		connect();
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne(queryID, param);
			session.commit();
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
			session.rollback();
		}
		finally {
			session.close();
		}

		//LOG.debug("! [G20] Map<String, Object> result >> " + result.toString());
		LOG.debug("- [G20] AcG20Ex2ErpDAO - insert");

		return result;
	}
	
	public Map<String, Object> getErpOption(Map<String, Object> param) {
		return select("AcG20Ex2Erp.getErpOption", param);
	}
	
}
