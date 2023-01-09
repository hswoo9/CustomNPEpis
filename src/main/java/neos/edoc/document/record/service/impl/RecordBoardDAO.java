package neos.edoc.document.record.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.util.jstree.TreeDaoVO;
import neos.edoc.document.record.vo.RecordBoardVO;
import neos.edoc.document.record.vo.RecordDetailVO;

@Repository("RecordBoardDAO")
public class RecordBoardDAO extends EgovComAbstractDAO {

	Map<String, Object> getRecordInnerDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo){		
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordInnerDocList");			
	}
    
	Map<String, Object> getRecordReceiveDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo){		
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordReceiveDocList");			
	}
    
	Map<String, Object> getRecordSendDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo){		
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordSendDocList");			
	}
    
    Map<String, Object> getRecordMyDraftDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo){		
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordMyDraftDocList");			
	}
    
	Map<String, Object> getRecordMyReceiveDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo){		
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordMyReceiveDocList");			
	}
    
    @SuppressWarnings("unchecked")
    public List<RecordBoardVO> countReadingInfo(RecordBoardVO recordboardVO) throws Exception {
    	return list("RecordBoardDAO.countReadingInfo", recordboardVO);
    }
    
    /**
     * 조건에 맞는 기록물철별문서 목록을 조회 한다.
     * 
     * @param boardVO
     * @return
     * @throws Exception
     */
//    @SuppressWarnings("unchecked")
//    public List<RecordBoardVO> recordArchiveBoardArticleList(RecordBoardVO recordboardVO) throws Exception {
//    	return list("RecordBoardDAO.recordArchiveBoardArticles", recordboardVO);
//    }    
    
    public Map<String, Object> recordArchiveBoardArticleList(Map<String, Object> paramMap , PaginationInfo paginationInfo){
        return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.recordArchiveBoardArticles");
    }
    
    /**
     * 열람지정자 목록을 조회 한다.
     * 
     * @param boardVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<RecordBoardVO> selectReadingStatus(RecordBoardVO recordboardVO) throws Exception {
    	return list("RecordBoardDAO.selectReadingStatus", recordboardVO);
    }
    
    
    
    /**
     * 기관,부서 정보를 트리구조로 가져온다.
     * 
     * @param HashMap paraMap
     * @return List<TreeDaoVO> resultMap
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<TreeDaoVO> selectTreeUser(HashMap<String, Object> paraMap) throws Exception{
    	List<TreeDaoVO> resultList = list("RecordBoardDAO.selectTreeUser", paraMap);    	    	    	
    	return resultList;
    }
    
    @SuppressWarnings("unchecked")
    public List<TreeDaoVO> selectDeptUser(HashMap<String, Object> paraMap) throws Exception{
    	List<TreeDaoVO> resultList = list("RecordBoardDAO.selectDeptUser", paraMap);    	    	    	
    	return resultList;
    }
    
    /**
     * 기록물철을 트리구조로 가져온다.
     * 
     * @param HashMap paraMap
     * @return List<TreeDaoVO> resultMap
     * @throws Exception
     */
//    @SuppressWarnings("unchecked")
//    public List<TreeDaoVO> selectTreeArchive(HashMap paraMap) throws Exception{
//    	List<TreeDaoVO> resultList = list("RecordBoardDAO.selectTreeArchive", paraMap);    	    	    	
//    	return resultList;
//    }
    
    @SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTreeArchive(HashMap<String, Object> paraMap) {
    	 
//    	if( EgovStringUtil.isEmpty((String)paraMap.get("selectType")) ){
    		return (List<Map<String, Object>>) list("RecordBoardDAO.selectTreeArchive", paraMap);	
//    	}else{
//    		return (List<Map>) list("RecordBoardDAO.selectTreeArchiveForEdms", paraMap);
//    	}         
    }
    
    public void insertReadingStatus(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertReadingStatus", recordboardVO);
    }
    
//    public void insertReadingArchiveStatus(RecordBoardVO recordboardVO) throws Exception {
//    	insert("RecordBoardDAO.insertReadingArchiveStatus", recordboardVO);
//    }
    
    public void insertReadingInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertReadingInfo", recordboardVO);
    }
    
    public void deleteReadingStatus(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.deleteReadingStatus", recordboardVO);
    }
    
    public void updateReadingInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.updateReadingInfo", recordboardVO);
    	insert("RecordBoardDAO.updateReadingStatusInfo", recordboardVO);
    }
    
    public List<RecordBoardVO> selectArchive(RecordBoardVO recordboardVO) throws Exception {
    	List<RecordBoardVO> resultList = list("RecordBoardDAO.selectArchive",recordboardVO);
    	return resultList;
    }
    
    public RecordBoardVO selectDocAchiveInfo(RecordBoardVO recordboardVO) throws Exception {
        return (RecordBoardVO)selectByPk("RecordBoardDAO.selectArchive", recordboardVO);
    }
    
    public int insertDocInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertDocInfo", recordboardVO);
    	return 1;
    }
    
    public int insertRecordInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertRecordInfo", recordboardVO);
    	return 1;
    }
    
    public void insertReceiveInfo(RecordBoardVO recordboardVO) {
    	insert("RecordBoardDAO.insertReceiveInfo", recordboardVO);
	}
	
    public void updateRhpage(RecordBoardVO recordboardVO) throws Exception {
    	update("RecordBoardDAO.updateRhpage", recordboardVO);
    }
    
    public void insertNonDocInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertNonDocInfo", recordboardVO);
    }
    
    public void insertNonDraftInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertNonDraftInfo", recordboardVO);
    }
    public void insertNonReceiveInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertNonReceiveInfo", recordboardVO);
    }
    public void insertNonRecordInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertNonRecordInfo", recordboardVO);
    }
    
    public void insertNonAttachInfo(RecordBoardVO recordboardVO) throws Exception {
    	insert("RecordBoardDAO.insertNonAttachInfo", recordboardVO);
    }
    
    public int reArchive(RecordBoardVO recordboardVO) throws Exception {
    	int i = update("RecordBoardDAO.reArchive", recordboardVO);
    	return i;
    }
    
    public List<Map> selectArchiveInfo(RecordBoardVO recordboardVO) throws Exception {
    	return list("RecordBoardDAO.selectArchiveInfo", recordboardVO);
    }
    
    public int updateDocSecret(RecordBoardVO recordboardVO) throws Exception {//yj
    	int i = update("RecordBoardDAO.updateDocSecret", recordboardVO);
    	return i;
    }
    
    public int docDelete(RecordBoardVO recordboardVO) throws Exception {//yj
    	int i = update("RecordBoardDAO.docDelete", recordboardVO);
    	return i;
    }
    
    public Integer docLinkChk(RecordBoardVO recordboardVO) throws Exception{
    	return (Integer) selectByPk("RecordBoardDAO.docLinkChk", recordboardVO);
    }
    
    public String authorityChk(RecordBoardVO recordboardVO) throws Exception {
    	String authorityChk = (String) selectByPk("RecordBoardDAO.authorityChk", recordboardVO);
    	return authorityChk;
    }


    public RecordDetailVO selectDocDetailInfo(RecordBoardVO recordBoardVO) {
        return (RecordDetailVO)selectByPk("RecordBoardDAO.selectDocDetailInfo", recordBoardVO);
    }

    public RecordDetailVO selectDocDetailInfoForEdms(RecordBoardVO recordBoardVO) {
        return (RecordDetailVO)selectByPk("RecordBoardDAO.selectDocDetailInfoForEdms", recordBoardVO);
    }    
    
    @SuppressWarnings("unchecked")
    public List<RecordBoardVO> selectDocFileList(RecordBoardVO recordBoardVO) {
        return  list("RecordBoardDAO.selectDocFileList", recordBoardVO);
    }
    
    @SuppressWarnings("unchecked")
    public List<RecordBoardVO> selectDocFileListForEdms(RecordBoardVO recordBoardVO) {
        return  list("RecordBoardDAO.selectDocFileListForEdms", recordBoardVO);
    }
    
//    @SuppressWarnings("unchecked")
//    public List<HashMap<String, Object>> getReadingAlarm(RecordBoardVO recordboardVO) throws Exception {
//    	return list("RecordBoardDAO.getReadingAlarm", recordboardVO);
//    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMappingReadingStatus(Map<String, Object> params) throws Exception {
		return list("RecordBoardDAO.selectMappingReadingStatus", params);
	}

	/** 
	 * selectTreeOrganization doban7 2016. 10. 14.
	 * @param paraMap
	 * @return
	 */
//	public List<TreeDaoVO> selectTreeOrganization(HashMap<String, Object> paraMap) {
//    	return (List<TreeDaoVO>) list("RecordBoardDAO.selectTreeOrganization", paraMap); 
//	}

	public Map<String, Object> getRecordAuditDocList(Map<String, Object> paramMap , PaginationInfo paginationInfo) {
		return super.listOfPaging2(paramMap, paginationInfo, "RecordBoardDAO.getRecordAuditDocList");
	}

	@SuppressWarnings("deprecation")
	public Integer getReadingStatusUserCnt(RecordBoardVO recordboardVO) {
		return (Integer) selectByPk("RecordBoardDAO.getReadingStatusUserCnt", recordboardVO);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getLastReadingUserList(Map<String, Object> paramMap) {
		return (List<Map<String, Object>>) list("RecordBoardDAO.getLastReadingUserList", paramMap);
	}

	public void insertReadingStatusMulti(Map<String, Object> paramMap) {
		insert("RecordBoardDAO.insertReadingStatusMulti", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectRecordTransList(RecordBoardVO recordBoardVO) {
		return (List<Map<String, Object>>) list("RecordBoardDAO.selectRecordTransList", recordBoardVO);
	}

}
