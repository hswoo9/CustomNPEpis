package neos.cmm.util.code.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.sym.ccm.cde.service.CmmnDetailCodeParamVO;
import egovframework.com.sym.ccm.cde.service.CmmnDetailCodeVO;

/**
 * 
 * @title 코드 관리 DAO
 * @author 공공사업부 포털개발팀 남정환
 * @since 2012. 5. 10.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 10.  남정환        최초 생성
 * 2012. 5. 15.  박기환        메소드 추가
 */

@Repository("CommonCodeDAO")
public class CommonCodeDAO extends EgovComAbstractDAO {
	
    public List<Map<String, String>> selectCommonCode() throws Exception{
    	
		List<Map<String, String>> resultList = (List<Map<String, String>>) list("CommonCodeInfo.selectCommonInfo",null);    	    	
    	return resultList;
    }
    
    
    /**
     * 공통코드 목록을 가져온다. (ISCHILD 가 'Y'  인것만)
     * 
     * @param searchVO 
     * @return
     * @throws Exception
     */
    public List<Map<String, String>> selectChildCommonCode() throws Exception{
    	
		List<Map<String, String>> resultList = (List<Map<String, String>>) list("CommonCodeInfo.selectChildCommonInfo",null);    	    	
    	return resultList;
    }
    
    /**
     * 공통코드 목록을 가져온다.
     * 
     * @param searchVO 
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<CmmnDetailCodeVO> selectCommonCodeList(CmmnDetailCodeParamVO searchVO) throws Exception{
    	List<CmmnDetailCodeVO> resultList = (List<CmmnDetailCodeVO>) list("CommonCodeInfo.selectCmmnDetailCodeList", searchVO);    	    	    	
    	return resultList;
    }
    
    /**
	 * 공통코드를 삭제한다.
	 * @param vo SndngMailVO
	 * return String
	 * @exception
	 */
    public String deleteCmmnCode(CmmnDetailCodeVO searchVO) throws Exception {
    	
        delete("CommonCodeInfo.deleteCmmnCode", searchVO);
        
        return "delete";
    }
    
    /**
	 * 공통코드를 입력한다.(모바일Push Address를 공통코드에 저장하기 위해서 만듬)
	 * @param CmmnDetailCodeVO
	 * return int
	 * @exception
	 */
    public int insertCmmnCode(CmmnDetailCodeVO searchVO) throws Exception {    	
        insert("CommonCodeInfo.insertCmmnCode", searchVO);
        return 1;
    }
    
    /**
	 * 공통코드를 수정한다.(모바일Push Address를 공통코드에 저장하기 위해서 만듬)
	 * @param CmmnDetailCodeVO
	 * return int
	 * @exception
	 */
    public int updateCmmnCode(CmmnDetailCodeVO searchVO) throws Exception {    	
        update("CommonCodeInfo.updateCmmnCode", searchVO);
        return 1;
    }
}
