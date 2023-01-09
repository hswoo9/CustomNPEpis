package ac.g20.app.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.duzon.custom.common.utiles.EgovStringUtil;

import ac.g20.app.service.AcG20ExAppService;
import ac.g20.ex.vo.Abdocu_H;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.code.CommonCodeUtil;
import neos.edoc.eapproval.link.service.DocLinkApprovalService;

@Service("ICubeG20Service")
public class ICubeG20ServiceImpl implements DocLinkApprovalService {
	
	@Resource(name = "AcG20ExAppService")
	private AcG20ExAppService	acG20ExAppService;
	
	/*@Resource(name = "twoPhaseSql")
	private TwoPhaseSqlDAO commonSql;*/
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;


	public void selectApproval(Map<String, Object> paramMap, String approKey,
													Model model) throws Exception {
		String childCode = (String)paramMap.get("childCode");
		String childCodeDetail = (String)paramMap.get("childCodeDetail");
		String codeName = CommonCodeUtil.getCodeName("G20MUP", childCode + childCodeDetail ) ;
		String multiDocYN = codeName ;
		if ( EgovStringUtil.isEmpty(codeName ) ) {
			multiDocYN = "N";
		}
		Map<String, Object>resultMap =  null ;
		if ( multiDocYN.equals("Y") ) {
//			resultMap = docDraftService.docG20MultiApproval(paramMap);
			resultMap = acG20ExAppService.docG20MultiApproval(paramMap);
		}else {
			resultMap = acG20ExAppService.docG20Approval(paramMap);
		}
		
		resultMap.put("multiDocYN", multiDocYN);
		model.addAllAttributes(resultMap);
		
  		String itemDetailYN = CommonCodeUtil.getCodeName("G20301", "001"); 
  		if("Y".equals(itemDetailYN )) {
			String abDocuNo = (String)paramMap.get("docxNumb");
//			resultMap = docDraftService.docG20ItemDetail(abDocuNo) ; //명세서, 출장.
			resultMap = acG20ExAppService.docG20ItemDetail(abDocuNo) ; //명세서, 출장.
			model.addAllAttributes(resultMap);
  		}
		model.addAttribute("diSeqNum", paramMap.get("diSeqNum"));
		model.addAttribute("miSeqNum", paramMap.get("miSeqNum") );
		model.addAttribute("backupKlUserKey", paramMap.get("backupKlUserKey") );
	}

	public void approvalTempSave(Map<String, Object> paramMap, String approKey)
			throws Exception {

	}

	public void approvalReserve(Map<String, Object> paramMap, String approKey)
			throws Exception {

	}

	public void approvalDraftSave(Map<String, Object> paramMap, String approKey)
			throws Exception {
		String diKeyCode = EgovStringUtil.isNullToString(paramMap.get("diKeyCode")) ;
		String draftStatus = "" ;
		String sessionID = (String)paramMap.get("sessionID") ;
		Map<String, Object> approvalUser = null ;
		@SuppressWarnings("unchecked")
		List <Map<String, Object> > approvalUserList =  (List <Map<String, Object> >)paramMap.get("approvalUserList")  ; //결재자 정보
		Abdocu_H abdocuH = new Abdocu_H();
		abdocuH.setC_dikeycode(diKeyCode);
		abdocuH.setAbdocu_no(approKey) ;
		approvalUser = approvalUserList.get(0) ;
		draftStatus = (String)approvalUser.get("draftStatus") ;
		String docu_mode = (String)paramMap.get("docu_mode") ;
		String abdocu_no_reffer = (String)paramMap.get("abdocu_no_reffer") ;
		String docxGubn =  EgovStringUtil.isNullToString(paramMap.get("docxGubn"));
		String diStatus = EgovStringUtil.isNullToString(paramMap.get("paramDiStatus")) ;

		if ( EgovStringUtil.isEmpty(docxGubn) )  {
			docxGubn =  EgovStringUtil.isNullToString(paramMap.get("ciKind")) ;
		}
		if("000".equals(draftStatus)) {
			abdocuH.setSessionid(sessionID);
			// 예산잔액 확인
			abdocuH.setDocu_mode(docu_mode) ;
			abdocuH.setAbdocu_no_reffer(abdocu_no_reffer) ;

			if(docxGubn.equals("010")) {
				acG20ExAppService.completeApproval(abdocuH); //품의서
			}else if (docxGubn.equals("011") ) {
				acG20ExAppService.insertG20Data(abdocuH); //결의서
			}
		}
	}

	public void approvalDraftReturn(Map<String, Object> paramMap, String approKey)
			throws Exception {
		String diKeyCode =  EgovStringUtil.isNullToString(paramMap.get("diKeyCode"));
		Abdocu_H abdocuH = new Abdocu_H();
		abdocuH.setC_dikeycode(diKeyCode);
		abdocuH.setAbdocu_no(approKey) ;
		String docxGubn =  EgovStringUtil.isNullToString(paramMap.get("docxGubn")) ;
		if ( EgovStringUtil.isEmpty(docxGubn) )  {
			docxGubn =  EgovStringUtil.isNullToString(paramMap.get("ciKind")) ;
		}
		if (docxGubn.equals("011") ) {
			acG20ExAppService.approvalReturn(abdocuH); //결재반려
		}

	}
	
	public void approvalLast(Map<String, Object> paramMap, String approKey)
			throws Exception {
		String diKeyCode =  (String)paramMap.get("diKeyCode") ;
		
		Abdocu_H abdocuH = new Abdocu_H();
		abdocuH.setC_dikeycode(diKeyCode);
		abdocuH.setAbdocu_no(approKey) ;
		String docxGubn =  EgovStringUtil.isNullToString(paramMap.get("docxGubn")) ;
		if ( EgovStringUtil.isEmpty(docxGubn) )  {
			docxGubn =  EgovStringUtil.isNullToString(paramMap.get("ciKind")) ;
		}
		String diStatus = EgovStringUtil.isNullToString(paramMap.get("paramDiStatus")) ;
		
		if ( "999".equals(diStatus) &&   docxGubn.equals("011") ) {
			String docNum = (String)commonSql.selectByPk("EApprovalWriteDAO.selectDocNum", diKeyCode);
			abdocuH.setDocnumber(docNum);
			acG20ExAppService.approvalEnd(abdocuH); //결재완료
		}
		acG20ExAppService.completeApproval(abdocuH);

	}

	public void approvalRecovery(Map<String, Object> paramMap, String approKey)
			throws Exception {
		
		String diKeyCode =EgovStringUtil.isNullToString(paramMap.get("diKeyCode"));
		Abdocu_H abdocu = new Abdocu_H();
		abdocu.setC_dikeycode(diKeyCode);
		abdocu.setAbdocu_no(approKey);
		
		String docxGubn =  EgovStringUtil.isNullToString(paramMap.get("docxGubn")) ;
		if ( EgovStringUtil.isEmpty(docxGubn) )  {
			docxGubn =  EgovStringUtil.isNullToString(paramMap.get("ciKind")) ;
		}
		if (docxGubn.equals("011") ) {
			acG20ExAppService.approvalReturn(abdocu); //결재반려
		}
		
	}

	public void approvalDelete(Map<String, Object> paramMap, String approKey)
			throws Exception {

	}

	public void approvalStateChange(Map<String, Object> paramMap, String approKey)
			throws Exception {
		
	}
	
	public boolean isAudit(Map<String, Object> paramMap, String approKey)
			throws Exception {
		return false;
	}

	public int getAuditType(Map<String, Object> paramMap, String approKey)
			throws Exception {
		return 0;
	}

	public List<Map<String, Object>> approvalKyuljaeLine(Map<String, Object> paramMap, String approKey)
			throws Exception {
		return null;
	}

}
