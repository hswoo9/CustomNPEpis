package com.duzon.custom.common.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;

/**
 * 기본 DAO
 * @author iguns
 *
 */
public class AbstractDAO {
    protected Log log = LogFactory.getLog(AbstractDAO.class);
     
    @Resource(name="sqlSessionTemplate")  
    protected SqlSessionTemplate sqlSession;
    
    @Resource(name="sqlSessionTemplateMs")  
    protected SqlSessionTemplate sqlSessionMs;
    
    @Resource(name="sqlSessionTemplateMs2")  
    protected SqlSessionTemplate sqlSessionMs2;
    
    @Resource(name="sqlSessionTemplateOr")  
    protected SqlSessionTemplate sqlSessionOr;
    
    @Resource(name="sqlSessionTemplateOr2")  
    protected SqlSessionTemplate sqlSessionOr2;
    
    @Resource(name="sqlSessionTemplateOr3")  
    protected SqlSessionTemplate sqlSessionOr3;
     
    protected void printQueryId(String queryId) {
        if(log.isDebugEnabled()){
            log.debug("\t QueryId  \t:  " + queryId);
        }
    }
     
    public Object insert(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.insert(queryId, params);
    }
     
    public Object update(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.update(queryId, params);
    }
     
    public Object delete(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.delete(queryId, params);
    }
     
    public Object selectOne(String queryId){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId);
    }
     
    public Object selectOne(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId){
        printQueryId(queryId);
        return sqlSession.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectList(String queryId, Object params){
        printQueryId(queryId);
        return sqlSession.selectList(queryId,params);
    }
    
    
    //mssql
    public Object insertMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.insert(queryId, params);
    }
     
    public Object updateMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.update(queryId, params);
    }
     
    public Object deleteMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.delete(queryId, params);
    }
     
    public Object selectOneMs(String queryId){
        printQueryId(queryId);
        return sqlSessionMs.selectOne(queryId);
    }
     
    public Object selectOneMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs(String queryId){
        printQueryId(queryId);
        return sqlSessionMs.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.selectList(queryId,params);
    }
    
    @SuppressWarnings("rawtypes")
    public List<List<Map<String, Object>>> selectListListMs(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs.selectList(queryId,params);
    }
    
  //mssql2
    public Object insertMs2(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs2.insert(queryId, params);
    }
     
    public Object updateMs2(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs2.update(queryId, params);
    }
     
    public Object deleteMs2(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs2.delete(queryId, params);
    }
     
    public Object selectOneMs2(String queryId){
        printQueryId(queryId);
        return sqlSessionMs2.selectOne(queryId);
    }
     
    public Object selectOneMs2(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs2.selectOne(queryId, params);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs2(String queryId){
        printQueryId(queryId);
        return sqlSessionMs2.selectList(queryId);
    }
     
    @SuppressWarnings("rawtypes")
    public List selectListMs2(String queryId, Object params){
        printQueryId(queryId);
        return sqlSessionMs2.selectList(queryId,params);
    }
    
    //oracle
    public Object insertOr(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr.insert(queryId, params);
    }
    
    public Object updateOr(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr.update(queryId, params);
    }
    
    public Object deleteOr(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr.delete(queryId, params);
    }
    
    public Object selectOneOr(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr.selectOne(queryId);
    }
    
    public Object selectOneOr(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr.selectOne(queryId, params);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr.selectList(queryId);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr.selectList(queryId,params);
    }
    
    //oracle2
    public Object insertOr2(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.insert(queryId, params);
    }
    
    public Object updateOr2(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.update(queryId, params);
    }
    
    public Object deleteOr2(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.delete(queryId, params);
    }
    
    public Object selectOneOr2(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr2.selectOne(queryId);
    }
    
    public Object selectOneOr2(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.selectOne(queryId, params);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr2(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr2.selectList(queryId);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr2(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.selectList(queryId,params);
    }
    //oracle3
    public Object insertOr3(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr2.insert(queryId, params);
    }
    
    public Object updateOr3(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr3.update(queryId, params);
    }
    
    public Object deleteOr3(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr3.delete(queryId, params);
    }
    
    public Object selectOneOr3(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr3.selectOne(queryId);
    }
    
    public Object selectOneOr3(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr3.selectOne(queryId, params);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr3(String queryId){
    	printQueryId(queryId);
    	return sqlSessionOr3.selectList(queryId);
    }
    
    @SuppressWarnings("rawtypes")
    public List selectListOr3(String queryId, Object params){
    	printQueryId(queryId);
    	return sqlSessionOr3.selectList(queryId,params);
    }
}
