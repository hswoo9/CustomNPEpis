package ac.g20.ex.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.dao.AcG20ExErpDAO;
import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.dao.AcG20StateErpDAO;
import ac.g20.ex.dao.AcG20StateGwDAO;
import ac.g20.ex.service.AcG20StateService;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.StateVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.edoc.document.record.service.impl.RecordBoardDAO;
import neos.edoc.document.record.vo.RecordBoardVO;
import neos.edoc.eapproval.reportstoragebox.service.impl.ReportStorageDocumentDAO;

/**
 * 
 * @title AcG20StateServiceImpl.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
@Service("AcG20StateService")
public class AcG20StateServiceImpl implements AcG20StateService {

	@Resource(name = "AcG20StateErpDAO")
	private AcG20StateErpDAO	acG20StateErpDAO;
	//	
	@Resource(name = "AcG20StateGwDAO")
	private AcG20StateGwDAO		acG20StateGwDAO;

	@Resource(name = "AcG20ExErpDAO")
	private AcG20ExErpDAO	acG20ExErpDAO;
	
	@Resource(name = "AcG20ExGwDAO")
	private AcG20ExGwDAO	acG20ExGwDAO;
	
    @Resource(name = "RecordBoardDAO")
    private RecordBoardDAO recordBoardDAO;
    
    @Resource(name="ReportStorageDocumentDAO")
    ReportStorageDocumentDAO reportStorageDocumentDAO;
	
	/**
	 * doban7 2016. 10. 26. getSbgtLevel
	 **/
	@Override
	public List<HashMap<String, Object>> getErpSbgtLevel(HashMap<String, String> param, ConnectionVO conVo) throws Exception {
		return acG20StateErpDAO.getErpSbgtLevel(param, conVo);
	}

	/**
	 * doban7 2016. 10. 27. getErpBgtCompareStatus
	 **/
	@Override
	public List<HashMap<String, Object>> getErpBgtCompareStatus(StateVO stateVO, ConnectionVO conVo) throws Exception {
		return acG20StateErpDAO.getErpBgtCompareStatus(stateVO, conVo);
	}

	/**
	 * doban7 2016. 10. 31. getErpBgtStepStatus
	 **/
	@Override
	public List<HashMap<String, Object>> getErpBgtStepStatus(StateVO stateVO, ConnectionVO conVo) throws Exception {
		return acG20StateErpDAO.getErpBgtSteStatus(stateVO, conVo);
	}

	/**
	 * doban7 2016. 11. 6. getBgtConsUseAmtList
	 **/
	@Override
	public List<HashMap<String, Object>> getBgtConsUseAmtList(StateVO stateVO) throws Exception {
		return acG20StateGwDAO.getBgtConsUseAmtList(stateVO);
	}

	/**
	 * doban7 2016. 11. 6. getBgtResUseAmtList
	 **/
	@Override
	public List<HashMap<String, Object>> getBgtResUseAmtList(StateVO stateVO) throws Exception {
		return acG20StateGwDAO.getBgtResUseAmtList(stateVO);
	}

	/**
	 * doban7 2016. 10. 31. getErpBgtExDetailList
	 **/
	@Override
	public List<HashMap<String, Object>> getErpBgtExDetailList(StateVO stateVO, ConnectionVO conVo) throws Exception {
		return acG20StateErpDAO.getErpBgtEaDetail(stateVO, conVo);
	}

	/**
	 * doban7 2016. 10. 31. getGwBgtExDetailList
	 **/
	@Override
	public List<HashMap<String, Object>> getGwBgtExDetailList(StateVO stateVO) throws Exception {
		return acG20StateGwDAO.getGwBgtExDetailList(stateVO);
	}

	/** 
	 * doban7 2016. 11. 13. 
	 * getAcExDocList
	 **/
	@Override
	public Map<String, Object> getAcExDocList(Map<String, Object> paramMap, PaginationInfo paginationInfo)
			throws Exception {
		return acG20StateGwDAO.getAcExDocList(paramMap, paginationInfo);
	}

	/** 
	 * doban7 2016. 11. 13. 
	 * getAcExDocDetail
	 **/
	@Override
	public List<HashMap<String, String>> getAcExDocDetail(Map<String, Object> paramMap) throws Exception {
		return acG20StateGwDAO.getAcExDocDetail(paramMap);
	}

	/** 
	 * doban7 2016. 11. 13. 
	 * delAcExDoc
	 **/
	@Override
	public HashMap<String, Object> delAcExDoc(Abdocu_H abdocu_Tmp, ConnectionVO conVo) throws Exception {

        HashMap<String, Object> result = new HashMap<String, Object>();
        
        Abdocu_H abdocu_h = acG20ExGwDAO.getAbdocuH(abdocu_Tmp);
        
        /*전표처리 여부 체크 */             
        int StatChk = (Integer) acG20ExErpDAO.chkErpAcExDocState(abdocu_h, conVo);
        int returnValue = 0;

        if(StatChk == 0){
            
        	/*참조 결의일경우 품의서 예산환원 취소*/
            if(abdocu_h.getAbdocu_no_reffer() != null && !abdocu_h.getAbdocu_no_reffer().equals("")){
                
                List<Abdocu_B> insertAbdocu_B_Tmp = acG20ExGwDAO.getAbdocuB_List(abdocu_h);
                for(int i = 0, max = insertAbdocu_B_Tmp.size(); i < max; i++) {
                    Abdocu_B abdocu_B = new Abdocu_B();
                    abdocu_B.setConfer_return(insertAbdocu_B_Tmp.get(i).getAbdocu_b_no_reffer());
                    Abdocu_B abdocu_B_Info = acG20ExGwDAO.getReturnConferBudgetRollBackInfo(abdocu_B);
                    if(abdocu_B_Info != null){
                    	acG20ExGwDAO.deleteAbdocu_B(abdocu_B_Info); 
                        result.put("rollbak", "rollbak");
                    }
                }
            }
            
            returnValue = delAcExDocGw(abdocu_h);
            
        }
        result.put("returnValue", returnValue);
        result.put("StatChk", StatChk);
        return result;
    }


	/** 
	 * doban7 2016. 11. 13. 
	 * delAcExDocConfer
	 **/
	@Override
	public HashMap<String, Object> delAcExDocConfer(Abdocu_H abdocu_Tmp) throws Exception {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		Abdocu_H abdocu_h = acG20ExGwDAO.getAbdocuH(abdocu_Tmp);
        
		/*참조결의서 존재 체크*/
        int StatChk = (Integer) acG20ExGwDAO.chkGwAcExDoExist(abdocu_h);
        int returnValue = 0;

        if(StatChk == 0 ){
            
        	returnValue = delAcExDocGw(abdocu_h);
        }
        result.put("returnValue", returnValue);
        result.put("StatChk", StatChk);
        return result;
	}   

	/** 
	 * delAcExDocGw doban7 2016. 11. 13.
	 * @param abdocu_h
	 * @return 
	 * @throws Exception 
	 */
	private int delAcExDocGw(Abdocu_H abdocu_h) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		int returnValue = 0;
		try{
			
	        HashMap<String, String> linkMap = new HashMap<String, String>();
            linkMap.put("apprDikey", abdocu_h.getC_dikeycode());
            linkMap.put("apprStatus", "d");
            linkMap.put("modifyId", loginVO.getId());
            linkMap.put("modifyUserkey", loginVO.getUniqId());
            acG20ExGwDAO.updateErpGwLink(linkMap);    // erpgwlink 'd' update 
            
            RecordBoardVO recordBoardVO = new RecordBoardVO();
            recordBoardVO.setC_dikeycode(abdocu_h.getC_dikeycode());
            recordBoardDAO.docDelete(recordBoardVO);   // a_recordinfo update
            
            List<String> diKeyCodeList = new ArrayList<String>();
            diKeyCodeList.add(abdocu_h.getC_dikeycode());
            reportStorageDocumentDAO.docTempDiStatusUpdate(diKeyCodeList);
            returnValue = 1;
            
        }catch(Exception e){
        	returnValue = -1;
            throw e ;
        }
		return returnValue;
	}
	
}
