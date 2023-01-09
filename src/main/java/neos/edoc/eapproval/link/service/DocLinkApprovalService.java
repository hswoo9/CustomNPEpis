package neos.edoc.eapproval.link.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;
/**
 * 
 * 
 *
 */
public interface DocLinkApprovalService {
	//감사여부 디폴트는 false
	public boolean isAudit(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	// 감사타입 디폴트 0    
	public int getAuditType(Map<String, Object>  paramMap, String approKey) throws Exception ;
		
	//조회
	public void selectApproval(Map<String, Object>  paramMap, String approKey, Model model) throws Exception ;
	
	//임시저장
	public void approvalTempSave(Map<String, Object>  paramMap, String approKey ) throws Exception ;
	
	//보류
	public void approvalReserve(Map<String, Object>  paramMap , String approKey) throws Exception ;
	
	//기안자 결재 
	public void approvalDraftSave(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	//반려 
	public void approvalDraftReturn(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	//최종결재
	public void approvalLast(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	//회수 
	public void approvalRecovery(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	//임시저장된 문서삭제 시 호출 
	public void approvalDelete(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
	//결재라인 API호출시 
	public List<Map<String, Object>> approvalKyuljaeLine(Map<String, Object> paramMap, String approKey) throws Exception;
	
	public void approvalStateChange(Map<String, Object>  paramMap, String approKey) throws Exception ;
	
}
