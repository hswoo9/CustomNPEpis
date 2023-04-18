/**
 * 
 */
package ac.g20.ex.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.vo.Abdocu_H;

/**
 * @title AcG20ExErpDAO.java
 * @author doban7
 *
 * @date 2016. 9. 5.
 */
@Repository("AcG20ExErpDAO")
public class AcG20ExErpDAO {

	/* 변수정의 */
	private SqlSessionFactory sqlSessionFactory;

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

	/**
	 * select doban7 2016. 9. 5.
	 * 
	 * @param string
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private HashMap<String, String> select(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {

		LOG.debug("+ [G20] AcG20ExErpDAO - select");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		HashMap<String, String> result = null;
		try {
			result = session.selectOne(queryID, paraMap);
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
		
		LOG.debug("! [G20] HashMap<String, String> result >> " + resultString);
		LOG.debug("- [G20] AcG20ExErpDAO - select");

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
	public Map<String, Object> insert(String queryID, Map<String, Object> paraMap, ConnectionVO conVo) {

		LOG.debug("+ [G20] AcG20ExErpDAO - insert");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		Map<String, Object> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne(queryID, paraMap);
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
		LOG.debug("- [G20] AcG20ExErpDAO - insert");

		return result;
	}

	/**
	 * chkErpBgtClose doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public HashMap<String, String> chkErpBgtClose(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - chkErpBgtClose >> AcG20ExErp.chkErpBgtClose");
		return select("AcG20ExErp.chkErpBgtClose", conVo, paraMap);
	}

	/**
	 * getErpGisuInfo doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public HashMap<String, String> getErpGisuInfo(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - getErpGisuInfo >> AcG20ExErp.getErpGisuInfo");
		return select("AcG20ExErp.getErpGisuInfo", conVo, paraMap);
	}

	/**
	 * getErpBudgetInfo doban7 2016. 9. 7.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public HashMap<String, String> getErpBudgetInfo(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - getErpBudgetInfo >> AcG20ExErp.getErpBudgetInfo");
		return select("AcG20ExErp.getErpBudgetInfo", conVo, paraMap);
	}

	/**
	 * getTaxConifg doban7 2016. 9. 21.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public HashMap<String, String> getErpTaxConifg(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - getErpTaxConifg >> AcG20ExErp.getErpTaxConifg");
		return select("AcG20ExErp.getErpTaxConifg", conVo, paraMap);
	}

	/**
	 * getErpACardSunginList doban7 2016. 10. 2.
	 * 
	 * @param requestMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpACardSunginList(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - getErpACardSunginList >> AcG20ExErp.getErpACardSunginList");
		return list("AcG20ExErp.getErpACardSunginList", conVo, paraMap);
	}

	/**
	 * getErpETCDUMMY1_Info doban7 2016. 10. 6.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public HashMap<String, String> getErpETCDUMMY1_Info(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20ExErpDAO - getErpETCDUMMY1_Info >> AcG20ExErp.getErpETCDUMMY1_Info");
		return select("AcG20ExErp.getErpETCDUMMY1_Info", conVo, paraMap);
	}

	/**
	 * getErpPayData doban7 2016. 10. 24.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, Object>> getErpPayData(HashMap<String, Object> paraMap, ConnectionVO conVo) {

		LOG.debug("+ [G20] AcG20ExErpDAO - getErpPayData");
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, Object>> result = null;
		try {
			result = session.selectList("AcG20ExErp.getErpPayData", paraMap);
		}
		catch (Exception e) {
			System.out.println(e);
		}
		finally {
			session.close();
		}

		LOG.debug("- [G20] AcG20ExErpDAO - getErpPayData");

		return result;
	}
	
	/** 
	 * chkErpAcExDocState doban7 2016. 11. 13.
	 * @param abdocu_h
	 * @param conVo 
	 * @return
	 */
	public Integer chkErpAcExDocState(Abdocu_H abdocu_h, ConnectionVO conVo) {
        Integer result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExErp.chkErpAcExDocState", abdocu_h);
			session.commit();
		}
		catch (Exception e) {
			System.out.println(e.getMessage());
			session.rollback();
		}
		finally {
			session.close();
		}
		
        return result;
	}

	public HashMap<String, String> getFixAm2(ConnectionVO conVo, Map<String, String> paraMap) {
		
		return select("AcG20ExErp.getFixAm2", conVo, paraMap);
	}
	
public List<HashMap<String, String>> getFixAm(ConnectionVO conVo, Map<String, String> paraMap) {
		
		return list("AcG20ExErp.getFixAm", conVo, paraMap);
	}

	public List<HashMap<String, String>> getErpSalaryInfo(ConnectionVO conVo, Map<String, String> paraMap) {
		return list("AcG20ExErp.getErpSalaryInfo", conVo, paraMap);
	}

	public List<HashMap<String, String>> payCmsList(ConnectionVO conVo, Map<String, String> map) {
		return list("AcG20ExErp.payCmsList", conVo, map);
	}

	public List<HashMap<String, String>> tkpPayYm(ConnectionVO conVo, Map<String, String> paraMap) {
		return list("AcG20ExErp.tkpPayYm", conVo, paraMap);
	}

	public List<HashMap<String, String>> paySctrlD(ConnectionVO conVo, Map<String, String> paraMap) {
		return list("AcG20ExErp.paySctrlD", conVo, paraMap);
	}

	public List<HashMap<String, String>> tkpPayCd(ConnectionVO conVo, Map<String, String> paraMap) {
		return list("AcG20ExErp.tkpPayCd", conVo, paraMap);
	}
	
}
