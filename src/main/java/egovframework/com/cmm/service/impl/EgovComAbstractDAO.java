/**
 *
 */
package egovframework.com.cmm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.DefaultPaginationManager;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationManager;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationRenderer;

/**
 * EgovComAbstractDAO.java 클래스
 *
 * @author 서준식
 * @since 2011. 9. 23.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2011. 9. 23.   서준식        최초 생성
 * </pre>
 */
public abstract class EgovComAbstractDAO extends EgovAbstractDAO{

	@Resource(name="sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }

	public String sqlSelectResultExcpetion(Object result){

		String sqlSelectResult = "";
		if(result==null){
			sqlSelectResult = "이 select sql은 결과값을 가져오지 않습니다.";
		}

		return sqlSelectResult;
	}	
	
	public Map<String, Object> listOfPaging(HttpServletRequest request , String queryID, Map<String, Object> paramMap, PaginationInfo paginationInfo ) {

		return listOfPaging(request, queryID, "" ,paramMap, paginationInfo) ;
	}
	
	public Map<String, Object> listOfPaging(HttpServletRequest request , String queryID, String prefixName, Map<String, Object> paramMap, PaginationInfo paginationInfo ) {
		Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;
		
		
		int startNum = paginationInfo.getFirstRecordIndex() + 1 ;
		int endNum =  paginationInfo.getLastRecordIndex() ;
		
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;
		
		List list =   super.list(queryID, paramMap) ;
		int totalCount =   0 ;
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
			map =  (Map<String, Object>)temp ;
			
			
			temp = map.get("TOTAL_COUNT") ;
			if(temp  != null  ) {
				totalCount = Integer.parseInt(temp.toString() ) ;
			}
		}
		
		resultMap.put(prefixName+"list", list) ;
		ServletContext sc = request.getSession().getServletContext();
		
		PaginationManager paginationManager = null ;
		WebApplicationContext ctx = RequestContextUtils.getWebApplicationContext(request, sc);
		
		
		if(ctx.containsBean("paginationManager")){
			paginationManager = (PaginationManager) ctx.getBean("paginationManager");
		}else{
			//bean 정의가 없다면 DefaultPaginationManager를 사용. 빈설정이 없으면 기본 적인 페이징 리스트라도 보여주기 위함.
			paginationManager = new DefaultPaginationManager();
		}
		
		paginationInfo.setTotalRecordCount(totalCount);
		int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() );
		PaginationRenderer paginationRenderer = paginationManager.getRendererType("image");
		
		String naviHtml = paginationRenderer.renderPagination(paginationInfo, prefixName+"goPage");
		resultMap.put(prefixName+"naviHtml", naviHtml) ;
		resultMap.put(prefixName+"startCount", startCount) ;
		resultMap.put(prefixName+"totalCount", totalCount) ;
		
		return resultMap ;
	}
	
	public Map<String, Object> listOfPaging2( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID, String prefixName ) {
		Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;
		
		int startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize())+1 ;
		int endNum = startNum + paginationInfo.getPageSize() - 1 ;
		
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;	
			
		int totalCount =   0 ;
		List list =   null;//super.list(queryID, paramMap) ;	
		startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize()) ;
		endNum = paginationInfo.getPageSize();
		
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;	
		
		totalCount = EgovStringUtil.zeroConvert(super.select(queryID+"_TOTALCOUNT", paramMap)+"");
		if(totalCount >= 0 ) list = super.list(queryID, paramMap) ; 
		
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
		}
		
		paginationInfo.setTotalRecordCount(totalCount);		
		resultMap.put(prefixName+"list", list) ;
		int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() ); 
		resultMap.put(prefixName+"startCount", startCount) ;
		resultMap.put(prefixName+"totalCount", totalCount) ;
		return resultMap;
		
	}
	public Map<String, Object> listOfPaging3(HttpServletRequest request, Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID, String prefixName ) {
        Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;
        
        int startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize())+1 ;
        int endNum = startNum + paginationInfo.getPageSize() - 1 ;
        
        paramMap.put("startNum", startNum) ;
        paramMap.put("endNum", endNum) ;    
            
        int totalCount =   0 ;
        List list =   null;//super.list(queryID, paramMap) ;    
        startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize()) ;
        endNum = paginationInfo.getPageSize();
        
        paramMap.put("startNum", startNum) ;
        paramMap.put("endNum", endNum) ;    
        
        totalCount = EgovStringUtil.zeroConvert(super.select(queryID+"_TOTALCOUNT", paramMap)+"");
        if(totalCount >= 0 ) list = super.list(queryID, paramMap) ; 
        
        if( list !=  null && !list.isEmpty()) {
            Map<String, Object> map = null ;
            Object temp = null ;
            temp  = list.get(0) ;
            if( temp == null) {
                return null ;
            }
        }
        
        paginationInfo.setTotalRecordCount(totalCount);     
        resultMap.put(prefixName+"list", list) ;
        int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() );
        
        
        /*test */
        ServletContext sc = request.getSession().getServletContext();
        
        PaginationManager paginationManager = null ;
        WebApplicationContext ctx = RequestContextUtils.getWebApplicationContext(request, sc);
        
        
        if(ctx.containsBean("paginationManager")){
            paginationManager = (PaginationManager) ctx.getBean("paginationManager");
        }else{
            //bean 정의가 없다면 DefaultPaginationManager를 사용. 빈설정이 없으면 기본 적인 페이징 리스트라도 보여주기 위함.
            paginationManager = new DefaultPaginationManager();
        }
        PaginationRenderer paginationRenderer = paginationManager.getRendererType("image");
        String naviHtml = paginationRenderer.renderPagination(paginationInfo, prefixName+"goPage");
        resultMap.put(prefixName+"naviHtml", naviHtml) ;        
        
        
        resultMap.put(prefixName+"startCount", startCount) ;
        resultMap.put(prefixName+"totalCount", totalCount) ;
        return resultMap;
        
    }
	public Map<String, Object> listOfPaging2 ( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID ) {
		return listOfPaging2(paramMap, paginationInfo, queryID, "") ;
	}
	public List list(String queryId, Object parameterObject) {
        return getSqlMapClientTemplate().queryForList(queryId, parameterObject);
    }	

	public Map<String, Object> listForMobile(String queryID, Map<String, Object> paramMap ) {
		Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;
				
		List list =   super.list(queryID, paramMap) ;
		int totalCount =   0 ;
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
		}
		
		resultMap.put("list", list) ;
		
		return resultMap ;
	}	
	
	public Map<String, Object> listOfPaging ( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID ) {
		return listOfPaging(paramMap, paginationInfo, queryID, "") ;
	}
	
	public Map<String, Object> listOfPaging( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID, String prefixName ) {
		
		Map<String ,Object> resultMap = new HashMap<String ,Object>(); ;

		int startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize()) ;
		int endNum = paginationInfo.getPageSize();
		
		paramMap.put("startNum", startNum);
		paramMap.put("endNum", endNum);
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;	
			
		int totalCount =   0 ;
		List list = super.list(queryID, paramMap);
		
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
			map =  (Map<String, Object>)temp ;
			temp = map.get("TOTAL_COUNT") ;
			if(temp  != null  ) {
				totalCount = Integer.parseInt(temp.toString() ) ;
			}
		}
		
		paginationInfo.setTotalRecordCount(totalCount);		
		resultMap.put(prefixName+"list", list) ;
		int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() ); 
		resultMap.put(prefixName+"startCount", startCount) ;
		resultMap.put(prefixName+"totalCount", totalCount) ;
		return resultMap;
		
	}	
	
}
