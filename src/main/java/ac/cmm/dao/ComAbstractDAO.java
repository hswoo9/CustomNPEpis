package ac.cmm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.duzon.custom.common.utiles.EgovStringUtil;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 기본 DAO
 * @author iguns
 *
 */
public class ComAbstractDAO {
    protected Log log = LogFactory.getLog(ComAbstractDAO.class);
     
    @Autowired
    protected SqlSessionTemplate sqlSession;
     
    protected void printQueryId(String queryId) {
        if(log.isDebugEnabled()){
            log.debug("\t QueryId  \t:  " + queryId);
        }
    }
     
    public Object insert(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.insert(queryId, params);
    }
     
    public int update(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.update(queryId, params);
    }
     
    public int delete(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.delete(queryId, params);
    }
     
    public Object selectByPk(String queryId){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId);
    }
     
    public Object selectByPk(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId, params);
    }
    
    public Object select(String queryId){
    	printQueryId(queryId);
    	return sqlSession.selectOne(queryId);
    }
    
    public Object select(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSession.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List list(String queryId){
        printQueryId(queryId);
        return sqlSession.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List list(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectList(queryId,params);
    }
    
    public Map<String, Object> listOfPaging2 ( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID ) {
		return listOfPaging2(paramMap, paginationInfo, queryID, "") ;
	}
    
    public Map<String, Object> listOfPaging2( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID, String prefixName ) {
		Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;
		
		int startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize())+1 ;
		int endNum = startNum + paginationInfo.getPageSize() - 1 ;
		
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;	
			
		int totalCount =   0 ;
		List list =   null;//super.list(queryID, paramMap) ;	
		/*if ( Globals.DB_TYPE.toLowerCase().equals("mysql") || Globals.DB_TYPE.toLowerCase().equals("mariadb"))  {*/
			startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize()) ;
			endNum = paginationInfo.getPageSize();
			
			paramMap.put("startNum", startNum) ;
			paramMap.put("endNum", endNum) ;	
			
			totalCount = EgovStringUtil.zeroConvert(sqlSession.selectOne(queryID+"_TOTALCOUNT", paramMap)+"");
			if(totalCount >= 0 ) list = sqlSession.selectList(queryID, paramMap) ; 
		/*} else {
			list = sqlSession.selectList(queryID, paramMap);
		}*/
		
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
			/*if ( !Globals.DB_TYPE.toUpperCase().equals("MYSQL") && !Globals.DB_TYPE.toLowerCase().equals("mariadb"))  {
				map =  (Map<String, Object>)temp ;
				temp = map.get("TOTAL_COUNT") ;
				if(temp  != null  ) {
					totalCount = Integer.parseInt(temp.toString() ) ;
				}
				
			}*/
		}
		
		paginationInfo.setTotalRecordCount(totalCount);		
		resultMap.put(prefixName+"list", list) ;
		int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() ); 
		resultMap.put(prefixName+"startCount", startCount) ;
		resultMap.put(prefixName+"totalCount", totalCount) ;
		return resultMap;
		
	}
}
