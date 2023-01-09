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
import org.springframework.stereotype.Repository;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.vo.StateVO;

/**
 * 
 * @title AcG20StateErpDAO.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
@Repository("AcG20StateErpDAO")
public class AcG20StateErpDAO {

	/* 변수정의 */
	private SqlSessionFactory	sqlSessionFactory;
	
	/* 공통사용 */
	/* 공통사용 - 커넥션 */
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
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
	 * @param queryID
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private List<HashMap<String, Object>> list(String queryID, ConnectionVO conVo, Object paraMap) {
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, Object>> result = null;
        try{
            result = session.selectList(queryID, paraMap);
        }catch(Exception e){
            System.out.println(e);
        }finally {
            session.close();
        }
        
		return result;
	}

	/** 
	 * select doban7 2016. 9. 5.
	 * @param string
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	@SuppressWarnings("unused")
	private  HashMap<String, String> select(String queryID, ConnectionVO conVo, Map<String, String> paraMap) {
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		HashMap<String, String> result = null;
        try{
            result = session.selectOne(queryID, paraMap);
        }catch(Exception e){
            System.out.println(e);
        }finally {
            session.close();
        }
		return result;
	}
	
	/**
	 * 
	 * insert doban7 2016. 9. 26.
	 * @param queryID
	 * @param param
	 * @param conVo
	 * @return
	 */
	public Map<String, Object> insert(String queryID, Map<String, Object> param, ConnectionVO conVo) {

		Map<String, Object> result = null;
		connect(conVo);
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

		return result;
	}

	/** 
	 * getSbgtLevel doban7 2016. 10. 26.
	 * @param param
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, Object>> getErpSbgtLevel(HashMap<String, String> param, ConnectionVO conVo) {
		return list("AcG20StateErp.getErpSbgtLevel", conVo, param);
	}

	/** 
	 * getErpBgtCompareStatus doban7 2016. 10. 27.
	 * @param stateVO
	 * @param conVo
	 * @return
	 */
	public List<HashMap<String, Object>> getErpBgtCompareStatus(StateVO stateVO, ConnectionVO conVo) {
		
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, Object>> result = null;
        try{
            result = session.selectList("AcG20StateErp.getErpBgtCompareStatus", stateVO);
        }catch(Exception e){
            System.out.println(e);
        }finally {
            session.close();
        }
        
		return result;
	}

	/** 
	 * getErpBgtSteStatus doban7 2016. 10. 31.
	 * @param stateVO
	 * @return
	 */
	public List<HashMap<String, Object>> getErpBgtSteStatus(StateVO stateVO, ConnectionVO conVo) {
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<HashMap<String, Object>> result = null;
        try{
            result = session.selectList("AcG20StateErp.getBudgetStepStatus", stateVO);
        }catch(Exception e){
            System.out.println(e);
        }finally {
            session.close();
        }
        
		return result;
	}

	/** 
	 * getErpBgtExDetailList doban7 2016. 10. 31.
	 * @param stateVO
	 * @return
	 */
	public List<HashMap<String, Object>> getErpBgtEaDetail(StateVO stateVO, ConnectionVO conVo) {
		return list("AcG20StateErp.getErpBgtEaDetail", conVo, stateVO);
	}
	

}
