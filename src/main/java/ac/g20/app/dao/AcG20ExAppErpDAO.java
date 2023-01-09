package ac.g20.app.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Repository;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_D;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import ac.g20.ex.vo.Abdocu_TD;
import ac.g20.ex.vo.Abdocu_TD2;
import ac.g20.ex.vo.Abdocu_TH;

/**
 * @title AcG20ExAppErpDAO.java
 * @author doban7
 *
 * @date 2016. 9. 5. 
 */
@Repository("AcG20ExAppErpDAO")
public class AcG20ExAppErpDAO {

	/* 변수정의 */
	private SqlSessionFactory	sqlSessionFactory;
	
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
	 * select doban7 2016. 9. 5.
	 * @param string
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
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
	 * insertG20Data_H doban7 2016. 9. 26.
	 * @param insertAbdocu_Tmp
	 * @param conVo 
	 * @return
	 */
	public Map<String, String> insertG20Data_H(Abdocu_H insertAbdocu_Tmp, ConnectionVO conVo) {
		
        Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu", insertAbdocu_Tmp);
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
	 * insertG20Data_B doban7 2016. 9. 26.
	 * @param abdocu_B_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_B(Abdocu_B abdocu_B_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_B", abdocu_B_Tmp);
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
	 * insertG20Data_T doban7 2016. 9. 26.
	 * @param abdocu_T_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_T(Abdocu_T abdocu_T_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
				result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_T", abdocu_T_Tmp);
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
	 * insertG20Data_TH doban7 2016. 9. 26.
	 * @param insertAbdocu_TH_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_TH(Abdocu_TH insertAbdocu_TH_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_TH", insertAbdocu_TH_Tmp);
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
	 * insertG20Data_TD doban7 2016. 9. 26.
	 * @param abdocu_TD_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_TD(Abdocu_TD abdocu_TD_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_TD", abdocu_TD_Tmp);
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
	 * insertG20Data_TD2 doban7 2016. 9. 26.
	 * @param abdocu_TD2_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_TD2(Abdocu_TD2 abdocu_TD2_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_TD2", abdocu_TD2_Tmp);
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
	 * insertG20Data_D doban7 2016. 9. 26.
	 * @param abdocu_D_Tmp
	 * @return
	 */
	public Map<String, String> insertG20Data_D(Abdocu_D abdocu_D_Tmp, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.insertErpAbdocu_D", abdocu_D_Tmp);
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
	 * deleteG20Data doban7 2016. 9. 26.
	 * @param paramMap
	 * @return
	 */
	public Map<String, String> deleteG20Data(Map<String, String> paramMap, ConnectionVO conVo) {
        return select("AcG20ExAppErp.delete-ErpData", conVo, paramMap);
	}

	/** 
	 * approvalReturn doban7 2016. 9. 26.
	 * @param param
	 * @return
	 */
	public Map<String, String> approvalReturn(Abdocu_H param, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.approvalReturn-Delete", param);
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
	 * approvalEnd doban7 2016. 9. 26.
	 * @param param
	 * @return
	 */
	public Map<String, String> approvalEnd(Abdocu_H param, ConnectionVO conVo) {
		Map<String, String> result = null;
		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			result = session.selectOne("AcG20ExAppErp.approvalEnd-Update", param);
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

}
