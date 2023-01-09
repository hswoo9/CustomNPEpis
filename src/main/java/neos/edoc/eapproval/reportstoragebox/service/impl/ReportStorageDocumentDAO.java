package neos.edoc.eapproval.reportstoragebox.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.edoc.eapproval.reportstoragebox.vo.ReportStorageDocumentParamVO;
import neos.edoc.eapproval.reportstoragebox.vo.ReportStorageDocumentVO;

@Repository("ReportStorageDocumentDAO")
public class ReportStorageDocumentDAO extends EgovComAbstractDAO{
	
	
    /**
     * 상신/보관함  - 양식목록
     */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	List<Map> selectFormList(Map<String, Object> vo){
		return (List<Map>)list("reportStorageDocumentDAO.selectFormList", vo);
	}
	
    /**
     * 상신/보관함  - 임시보관문서
     */
	Map<String, Object> tempStorageList(Map<String, Object> paramMap , PaginationInfo paginationInfo){
		
		return super.listOfPaging2(paramMap, paginationInfo, "reportStorageDocumentDAO.selectTempStorage");
		
		
	}

    /**
     * 상신/보관함  - 상신문서 - 회수
     */
	int approvalRollback(ReportStorageDocumentParamVO reportStorageDocumentParamVO){
		update("reportStorageDocumentDAO.approvalRollback", reportStorageDocumentParamVO);
		return 1;
	}

	/**
	 * 접수문서 회수시 삭제
	 */
	public int approvalReceiveDelRollback(ReportStorageDocumentParamVO reportStorageDocumentParamVO){
		update("reportStorageDocumentDAO.approvalReceiveDelMul", reportStorageDocumentParamVO);	
		update("reportStorageDocumentDAO.approvalReceiveDelKyul", reportStorageDocumentParamVO);	
		update("reportStorageDocumentDAO.approvalReceiveDelRecord", reportStorageDocumentParamVO);	
		update("reportStorageDocumentDAO.approvalReceiveUpReturn", reportStorageDocumentParamVO);
		update("reportStorageDocumentDAO.approvalReceiveDelDraft", reportStorageDocumentParamVO);
		return 1; 
	}

	/**
	 * 접수상신/보관함  - 접수 상신문서 - 회수
	 */
	int approvalReceiveRollback(ReportStorageDocumentParamVO reportStorageDocumentParamVO){
		update("reportStorageDocumentDAO.approvalReceiveRollback", reportStorageDocumentParamVO);
		return 1;
	}

	/**
	 * 접수상신/보관함  - 접수 상신문서 - 회수
	 */
	int approvalReceiveStatusRollback(Map<String, String> paramMap){
		return update("reportStorageDocumentDAO.approvalReceiveStatusRollback", paramMap);
	}
	
    /**
     * 공통적으로 iBatis 를 사용하여 목록을 조회한다.
     * 
     * @param ApprovalDocumentVO
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	List<ReportStorageDocumentVO> selectReportStorageList(String sqlMapKey, ReportStorageDocumentParamVO vo)
    {
    	List<ReportStorageDocumentVO> result = null;
    	try{
    		result = list(sqlMapKey, vo);
    	}
    	catch(Exception ex)
    	{
    		ex.printStackTrace();
    	}
    	return result;
    }

	public int setAllReading(HashMap<String, Object> param) {
		return update("reportStorageDocumentDAO.setRead", param);
	}

//	public Map<String, Object> selectSharedFolder(Map<String, Object> paramMap , PaginationInfo paginationInfo) {
//		return listOfPaging2(paramMap, paginationInfo, "reportStorageDocumentDAO.selectSharedFolder");
//	}

	public HashMap<String, String> getErpLinkInfo(
			ReportStorageDocumentParamVO reportStorageDocumentParamVO) {
		return (HashMap<String, String>)selectByPk("reportStorageDocumentDAO.getErpLinkInfo", reportStorageDocumentParamVO);
	}
	public Map<String, String> getDiStatusOfDraftInfo(String diKeyCode) {
		return (Map<String, String>)selectByPk("reportStorageDocumentDAO.selectDiStatusOfDraftInfo", diKeyCode);
	}

    /** 회수/반려함에서 문서 삭제 이혜영 2013-01-03  */
    public int returnCallBackDelete(ReportStorageDocumentParamVO reportStorageDocumentParamVO) {
        return update("reportStorageDocumentDAO.returnCallBackDelete", reportStorageDocumentParamVO);
    }
    /** 접수회수/반려함에서 문서 삭제 이혜영 2013-01-03  */
    public int returnCallBackReceiveDelete(ReportStorageDocumentParamVO reportStorageDocumentParamVO) {
    	return update("reportStorageDocumentDAO.returnCallBackReceiveDelete", reportStorageDocumentParamVO);
    }

    /** 임시보관함에서 삭제할 문서 키코드 가져오기 이혜영 2013-01-05  */
    @SuppressWarnings({ "unchecked"})
    public  List<String> tempDeleteKeycode(ReportStorageDocumentParamVO reportStorageDocumentParamVO) {
        return (List<String>)list("reportStorageDocumentDAO.tempDeleteKeycode", reportStorageDocumentParamVO);
    }
    

	public Map<String, Object> getDraftDoc(Map<String, Object> paramMap , PaginationInfo paginationInfo) {
		return super.listOfPaging2(paramMap, paginationInfo, "reportStorageDocumentDAO.selectDraftDoc");
	}

	public Map<String, Object> getReturnCallBack(Map<String, Object> paramMap , PaginationInfo paginationInfo) {
		return super.listOfPaging2(paramMap, paginationInfo, "reportStorageDocumentDAO.selectReturnCallBack");
	}
	
	public Map<String ,Object> getDetailDiKeyCodeTemplateInfo (String diKeyCode) {
		Map<String, Object> templateInfoMap =  (Map<String, Object>)selectByPk("EApprovalWriteDAO.detailDiKeyCodeDocTemplateInfo", diKeyCode) ;
		return templateInfoMap ;
	}

	public void docTempDiStatusUpdate(List<String> diKeyCodeList) {
		Map<String, List<String>>paramMap = new HashMap<String, List<String>>();
    	paramMap.put("diKeyCodeList", diKeyCodeList);
		update("EApprovalWriteDAO.updateDraftDiStatus", paramMap);
		
	}

	public Map<String, Object> getDocReadingList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return super.listOfPaging2(paramMap, paginationInfo, "reportStorageDocumentDAO.getDocReadingList");
	}
	
}
