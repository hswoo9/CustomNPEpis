package ac.g20.code.dao;

import java.io.Reader;
import java.util.ArrayList;
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

/**
 * @title AcG20CodeErpDAO.java
 * @author doban7
 *
 * @date 2016. 9. 1.
 */
@Repository("AcG20CodeErpDAO")
public class AcG20CodeErpDAO {

	/* 변수정의 */
	private SqlSessionFactory				sqlSessionFactory;

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
			e.printStackTrace();
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

		LOG.debug("+ [G20] AcG20CodeErpDAO - list");
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

		LOG.debug("- [G20] AcG20CodeErpDAO - list");

		return result;
	}

	private List<HashMap<String, Object>> listObj(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {

		LOG.debug("+ [G20] AcG20CodeErpDAO - listObj");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, Object>> result = null;
		try {
			result = session.selectList(queryID, paraMap);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}

		LOG.debug("- [G20] AcG20CodeErpDAO - listObj");

		return result;
	}

	/**
	 * 
	 * select doban7 2016. 9. 7.
	 * 
	 * @param queryID
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private HashMap<String, String> select(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {

		LOG.debug("+ [G20] AcG20CodeErpDAO - select");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		HashMap<String, String> result = null;
		try {
			result = session.selectOne(queryID, paraMap);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}

		LOG.debug("! [G20] HashMap<String, String> result >> " + result);
		LOG.debug("- [G20] AcG20CodeErpDAO - select");

		return result;
	}

	@SuppressWarnings("unused")
	private HashMap<String, Object> selectObj(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {

		LOG.debug("+ [G20] AcG20CodeErpDAO - selectObj");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		HashMap<String, Object> result = null;
		try {
			result = session.selectOne(queryID, paraMap);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}

		LOG.debug("! [G20] HashMap<String, String> result >> " + result);
		LOG.debug("- [G20] AcG20CodeErpDAO - selectObj");

		return result;
	}

	/**
	 * getErpConfig doban7 2016. 9. 2.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpConfigList(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpConfigList >> AcG20CodeErp.getErpConfigList");
		return list("AcG20CodeErp.getErpConfigList", conVo, paraMap);
	}

	/**
	 * getErpUser doban7 2016. 9. 1.
	 * 
	 * @param paraMap
	 * @return
	 */
	public HashMap<String, String> getErpUser(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpUser >> AcG20CodeErp.getErpUser");
		return select("AcG20CodeErp.getErpUser", conVo, paraMap);
	}

	/**
	 * getErpGISU doban7 2016. 9. 1.
	 * 
	 * @param paraMap
	 * @return
	 */
	public List<HashMap<String, Object>> getErpGISU(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpGISU >> AcG20CodeErp.getErpGISU");
		return listObj("AcG20CodeErp.getErpGISU", conVo, paraMap);
	}

	/**
	 * getErpDIVList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpDIVList(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpDIVList >> AcG20CodeErp.getErpDIVList");
		return list("AcG20CodeErp.getErpDIVList", conVo, paraMap);
	}

	/**
	 * getErpUserList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpUserList(HashMap<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpUserList >> AcG20CodeErp.getErpUserList");
		return list("AcG20CodeErp.getErpUserList", conVo, paraMap);
	}

	/**
	 * getErpMgtPjtList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpMgtPjtList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpMgtPjtList >> AcG20CodeErp.getErpMgtPjtList");
		return list("AcG20CodeErp.getErpMgtPjtList", conVo, paraMap);
	}

	/**
	 * getErpMgtDeptList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpMgtDeptList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpMgtDeptList >> AcG20CodeErp.getErpMgtDeptList");
		return list("AcG20CodeErp.getErpMgtDeptList", conVo, paraMap);
	}

	/**
	 * getErpAbgtBottomList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpAbgtBottomList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpAbgtBottomList >> AcG20CodeErp.getErpAbgtBottomList");
		return list("AcG20CodeErp.getErpAbgtBottomList", conVo, paraMap);
	}

	/**
	 * getErpBTRList doban7 2016. 9. 5.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpBTRList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpBTRList >> AcG20CodeErp.getErpBTRList");
		return list("AcG20CodeErp.getErpBTRList", conVo, paraMap);
	}

	/**
	 * getErpBudgetList doban7 2016. 9. 7.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpBudgetList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpBudgetList >> AcG20CodeErp.getErpBudgetList");
		return list("AcG20CodeErp.getErpBudgetList", conVo, paraMap);
	}
	
	/**
	 * getErpBudgetList asdlkjsb 2017. 7. 7.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpBudgetNameList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpBudgetList >> AcG20CodeErp.getErpBudgetList");
		return list("AcG20CodeErp.getErpBudgetNameList", conVo, paraMap);
	}
	

	/**
	 * getErpTradeList doban7 2016. 9. 7.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpTradeList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpTradeList >> AcG20CodeErp.getErpTradeList");
		return list("AcG20CodeErp.getErpTradeList", conVo, paraMap);
	}

	/**
	 * getErpEmpBankTrade 
	 */
	public List<HashMap<String, String>> getErpEmpBankTrade(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpTradeList >> AcG20CodeErp.getErpTradeList");
		return list("AcG20CodeErp.getErpEmpBankInfo", conVo, paraMap);
	}
	
	/**
	 * getErpBankList doban7 2016. 9. 22.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpBankList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpBankList >> AcG20CodeErp.getErpBankList");
		return list("AcG20CodeErp.getErpBankList", conVo, paraMap);
	}

	/**
	 * getErpEmpList doban7 2016. 9. 22.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpEmpList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpEmpList >> AcG20CodeErp.getErpEmpList");
		return list("AcG20CodeErp.getErpEmpList", conVo, paraMap);
	}

	/**
	 * getErpSempList doban7 2016. 9. 26.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpHpmeticList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpHpmeticList >> AcG20CodeErp.getErpHpmeticList");
		return list("AcG20CodeErp.getErpHpmeticList", conVo, paraMap);
	}

	/**
	 * 
	 * getErpHincomeList doban7 2016. 9. 26.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpHincomeList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpHincomeList >> AcG20CodeErp.getErpHincomeList");
		return list("AcG20CodeErp.getErpHincomeList", conVo, paraMap);
	}

	/**
	 * getErpEtcIncomeList doban7 2016. 10. 6.
	 * 
	 * @param paraMap
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, String>> getErpEtcIncomeList(Map<String, String> paraMap, ConnectionVO conVo) {
		LOG.debug("! [G20] AcG20CodeErpDAO - getErpEtcIncomeList >> AcG20CodeErp.getErpEtcIncomeList");
		return list("AcG20CodeErp.getErpEtcIncomeList", conVo, paraMap);
	}

}
