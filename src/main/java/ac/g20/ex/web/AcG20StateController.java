package ac.g20.ex.web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.common.utiles.EgovStringUtil;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.app.service.AcG20ExAppService;
import ac.g20.code.sercive.AcG20CodeService;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.service.AcG20StateService;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.StateVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.util.code.CommonCodeSpecific;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * G20 지출결의 관련 현황 메뉴 Controller
 * 
 * @title AcG20ExStateController.java
 * @author doban7
 *
 * @date 2016. 9. 1.
 */

@Controller
public class AcG20StateController {

	private org.apache.logging.log4j.Logger	LOG		= LogManager.getLogger(AcG20StateController.class);

	@Resource(name = "AcCommonService")
	AcCommonService							acCommonService;

	@Resource(name = "AcG20ExService")
	AcG20ExService							acG20ExService;

	@Resource(name = "AcG20CodeService")
	AcG20CodeService						acG20CodeService;

	@Resource(name = "AcG20StateService")
	AcG20StateService						acG20StateService;

	@Resource(name = "AcG20ExAppService")
	private AcG20ExAppService	acG20ExAppService;
	
	private ConnectionVO					conVo	= new ConnectionVO();

	/**
	 * GetConnection doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private ConnectionVO GetConnection() throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		return acCommonService.acErpSystemInfo(param);
	}

	/**
	 * ERP 회사코드 getCO_CD doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getCO_CD() {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpCoCd();
	}

	/**
	 * ERP 사원코드 getEMP_CD doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getEMP_CD() {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpEmpCd();
	}

	/**
	 * 언어정보 getLANGKIND doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getLANGKIND() {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getLangCode();
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/Ac/G20/State/AcStateInit.do")
	public ModelAndView AcExStateInit(@ModelAttribute("StateVO") StateVO stateVO, @RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		Date currentTime = new Date();
		String GISU_DT = formatter.format(currentTime);
		stateVO.setGISU_DT(GISU_DT);

		conVo = GetConnection();

		if (getCO_CD() == null || getEMP_CD() == null) { //연동된 회사코드, 사번 확인
			mv.addObject("resultValue", "empty");
			return mv;
		}

		stateVO.setCO_CD(getCO_CD());
		stateVO.setEMP_CD(getEMP_CD());
		// ERP 설정 파일 
		HashMap<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("CO_CD", getCO_CD());
		paraMap.put("EMP_CD", getEMP_CD());
		paraMap.put("LANGKIND", getLANGKIND());
		paraMap.put("GISU_DT", GISU_DT);

		Map<String, Object> erpUserInfo = getErpUser(conVo, paraMap);
		if (erpUserInfo.get("erpuser") == null) { // 연동된 회사코드 , 사번 확인
			mv.addObject("resultValue", "notExist");
			return mv;
		}

		List<HashMap<String, String>> erpConfig = acG20CodeService.getErpConfigList(conVo, paraMap);
		mv.addObject("erpConfig", JSONArray.fromObject(erpConfig));

		HashMap<String, String> gisuInfo = getErpGisuInfo(conVo, paraMap);

		if (gisuInfo != null && stateVO.getGISU().equals("")) {
			stateVO.setGISU(String.valueOf(gisuInfo.get("GI_SU")));
			stateVO.setFR_DT(gisuInfo.get("FROM_DT"));
			stateVO.setTO_DT(gisuInfo.get("TO_DT"));
			stateVO.setDATE_FROM(gisuInfo.get("FROM_DT"));
			stateVO.setDATE_TO(gisuInfo.get("TO_DT"));
		}

		HashMap<String, String> erpuser = new HashMap<String, String>();
		if (erpUserInfo.containsKey("erpuser")) {
			erpuser = (HashMap<String, String>) erpUserInfo.get("erpuser");
			stateVO.setDIV_CD(erpuser.get("DIV_CD"));
			stateVO.setCO_NM(erpuser.get("CO_NM"));
		}

		paraMap.put("BASE_DT", GISU_DT);
		List<HashMap<String, String>> div_List = acG20CodeService.getErpDIVList(conVo, paraMap);
		mv.addObject("div_List", div_List);

		List<HashMap<String, Object>> sbgtLevel = acG20StateService.getErpSbgtLevel(paraMap, conVo);
		mv.addObject("sbgtLevel", sbgtLevel);
		//        mv.addObject("sbgtLevel", JSONObject.fromObject(sbgtLevel));
		stateVO.setCO_CD(loginVO.getErpCoCd());
		stateVO.setEMP_CD(loginVO.getErpEmpCd());
		//        mv.addObject("budgetVO", budgetVO);
		mv.addObject("stateVO", JSONObject.fromObject(stateVO));
		mv.setViewName("jsonView");
		return mv;
	}

	/**
	 * 예실대비현황 BudgetConStatus doban7 2016. 10. 26.
	 * 
	 * @param stateVO
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/AcBgtCompareStatusView.do")
	public ModelAndView BudgetConStatus(@ModelAttribute("stateVO") StateVO stateVO, @RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		mv.setViewName("/ac/g20/state/AcBgtCompareStatusView");

		return mv;
	}

	/**
	 * 
	 * BudgetConStatus doban7 2016. 10. 26.
	 * 
	 * @param stateVO
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/AcBgtStepStatusView.do")
	public ModelAndView BudgetStepStatus(@ModelAttribute("BudgetVO") StateVO stateVO, @RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		mv.setViewName("/ac/g20/state/AcBgtStepStatusView");

		return mv;
	}

	/**
	 * 예실대비현황 데이터 가져오기 getErpBgtCompareStatus doban7 2016. 11. 7.
	 * 
	 * @param stateVO
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/getErpBgtCompareStatus.do")
	public ModelAndView getErpBgtCompareStatus(@ModelAttribute("BudgetVO") StateVO stateVO, @RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("CO_CD", loginVO.getErpCoCd());

		conVo = GetConnection();
		stateVO.setFR_DT(stateVO.getFR_DT().replaceAll("-", ""));
		stateVO.setTO_DT(stateVO.getTO_DT().replaceAll("-", ""));
		stateVO.setDATE_FROM(stateVO.getDATE_FROM().replaceAll("-", "") + "|");
		stateVO.setDATE_TO(stateVO.getDATE_TO().replaceAll("-", "") + "|");
		List<HashMap<String, Object>> result = null;
		try {
			result = acG20StateService.getErpBgtCompareStatus(stateVO, conVo);

			List<HashMap<String, Object>> totalList = new ArrayList<HashMap<String, Object>>(3);
			for (int i = 0; i < result.size(); i++) {

				if (result.get(i).get("R_DIV_FG").toString().equals("0")) {
					String colval = "";
					if (result.get(i).get("SUMMARY_YN").equals("1")) {
						colval = "수입합계";
					} else if (result.get(i).get("SUMMARY_YN").equals("2")) {
						colval = "지출합계";
					} else if (result.get(i).get("SUMMARY_YN").equals("3")) {
						colval = "잔      액";
					}
					result.get(i).put("BGT_CD", colval);
					totalList.add(result.get(i));
				}
			}

			for (int i = result.size() - 1; i >= 0; i--) {
				if (Integer.valueOf(stateVO.getDIV_FG().toString()) < Integer.valueOf(result.get(i).get("R_DIV_FG").toString()) || result.get(i).get("R_DIV_FG").toString().equals("0")) {
					result.remove(i);
				}
			}

			result.addAll(totalList);

		}
		catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		mv.addObject("selectList", result);

		mv.setViewName("jsonView");

		return mv;
	}

	/**
	 * 
	 * getErpBgtStepStatus doban7 2016. 10. 31.
	 * 
	 * @param stateVO
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/getErpBgtStepStatus.do")
	public ModelAndView getErpBgtStepStatus(@ModelAttribute("BudgetVO") StateVO stateVO, @RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		conVo = GetConnection();
		stateVO.setFR_DT(stateVO.getFR_DT().replaceAll("-", ""));
		stateVO.setTO_DT(stateVO.getTO_DT().replaceAll("-", ""));
		stateVO.setDATE_FROM(stateVO.getDATE_FROM().replaceAll("-", "") + "|");
		stateVO.setDATE_TO(stateVO.getDATE_TO().replaceAll("-", "") + "|");

		List<HashMap<String, Object>> result = null;
		try {
			result = acG20StateService.getErpBgtStepStatus(stateVO, conVo);

			Double TT_gwREFER_AM = 0.0000;
			//            Double TT_gwDIFF_AM = 0.0000;

			stateVO.setDATE_FROM(stateVO.getDATE_FROM().replaceAll("|", ""));
			stateVO.setDATE_TO(stateVO.getDATE_TO().replaceAll("|", ""));

			List<HashMap<String, Object>> gwBudgetInfo_1 = acG20StateService.getBgtConsUseAmtList(stateVO);
			List<HashMap<String, Object>> gwBudgetInfo_2 = acG20StateService.getBgtResUseAmtList(stateVO);
			HashMap<String, Object> totalList = null;
			
			double totalConfAm = 0.0000;
			for (int i = 0; i < result.size(); i++) {
				if (!result.get(i).get("SUMMARY_YN").toString().equals("Y")) {
					Double gw_APPLY_AM_1 = 0.0000;
					Double gw_APPLY_AM_2 = 0.0000;
					Double gwREFER_AM = 0.0000;
					Double gwDIFF_AM = 0.0000;
					Double DIFF_AM = 0.0000;
					String BGT_CD = (String) result.get(i).get("BGT_CD");
					for (int j = 0; gwBudgetInfo_1 != null && j < gwBudgetInfo_1.size(); j++) {
						if (BGT_CD.equals(gwBudgetInfo_1.get(j).get("ABGT_CD"))) {
							gw_APPLY_AM_1 = Double.parseDouble(getStringValue(gwBudgetInfo_1.get(j), "APPLY_AM", "0.0000"));
						}
					}

					for (int k = 0; gwBudgetInfo_2 != null && k < gwBudgetInfo_2.size(); k++) {
						if (BGT_CD.equals(gwBudgetInfo_2.get(k).get("ABGT_CD"))) {
							gw_APPLY_AM_2 = Double.parseDouble(getStringValue(gwBudgetInfo_2.get(k), "APPLY_AM", "0.0000"));
						}
					}

					Double preConfAm = 0.0000;
					Double confAm = 0.0000;
					preConfAm = Double.parseDouble( result.get(i).get( "PRE_CONF_AM" ).toString( ) );
					confAm = Double.parseDouble( result.get(i).get( "CONF_AM" ).toString( ) );
					
					
					gwREFER_AM = gw_APPLY_AM_1 - gw_APPLY_AM_2;
					DIFF_AM = Double.parseDouble(getStringValue(result.get(i), "CF_AM", "0.0000"));
					
					/* 금액 - 품의액 - 결의금액  */
					gwDIFF_AM = DIFF_AM - gwREFER_AM - preConfAm;
					totalConfAm += (preConfAm);
					
					TT_gwREFER_AM += gwREFER_AM;
					
					result.get(i).put("gwREFER_AM", gwREFER_AM);
					result.get(i).put("gwDIFF_AM", gwDIFF_AM);
				}

			}

			for (int i = 0; i < result.size(); i++) {

				if (result.get(i).get("SUMMARY_YN").toString().equals("Y")) {

					result.get(i).put("BGT_CD", "합계");
					Double DIFF_AM = 0.0000;
					DIFF_AM = Double.parseDouble(getStringValue(result.get(i), "DIFF_AM", "0.0000"));
					result.get(i).put("gwREFER_AM", TT_gwREFER_AM);
					result.get(i).put("gwDIFF_AM", DIFF_AM - TT_gwREFER_AM - totalConfAm);
					totalList = result.get(i);
					result.remove(i);
				}

			}

			result.add(totalList);
		}
		catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		mv.addObject("selectList", result);
		mv.setViewName("jsonView");
		return mv;
	}

	/**
	 * 
	 * AcBgtExDetailPop doban7 2016. 11. 7.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/AcBgtExDetailPop.do")
	public ModelAndView AcBgtExDetailPop(@RequestParam Map<String, Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.addObject("param", paramMap);
		mv.setViewName("/ac/g20/state/Popup/AcBgtExDetailPop");
		return mv;

	}

	/**
	 * 
	 * getErpBgtExDetailList doban7 2016. 11. 7.
	 * 
	 * @param paramMap
	 * @param stateVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/getErpBgtExDetailList.do")
	public ModelAndView getErpBgtExDetailList(@RequestParam Map<String, Object> paramMap, StateVO stateVO) throws Exception {

		ModelAndView mv = new ModelAndView();
		conVo = GetConnection();

		stateVO.setDATE_FROM(stateVO.getDATE_FROM().replaceAll("-", ""));
		stateVO.setDATE_TO(stateVO.getDATE_TO().replaceAll("-", ""));

		stateVO.setDATE_FROMS(stateVO.getDATE_FROM().replaceAll("-", "") + "|");
		stateVO.setDATE_TOS(stateVO.getDATE_TO().replaceAll("-", "") + "|");

		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		Date currentTime = new Date();
		String baseDate = formatter.format(currentTime);
		stateVO.setBASE_DT(baseDate);
		stateVO.setDIV_CDS(stateVO.getDIV_CD() + "|");
		stateVO.setLANGKIND(getLANGKIND());

		List<HashMap<String, Object>> selectList = null;
		try {
			selectList = acG20StateService.getErpBgtExDetailList(stateVO, conVo);
			Double TT_UNIT_AM = 0.0000;
			for (HashMap<String, Object> erpMap : selectList) {
				stateVO.setBGT_CD( erpMap.get( "BGT_CD" ).toString( ) );
				List<HashMap<String, Object>> docList = acG20StateService.getGwBgtExDetailList(stateVO);	
        		String DOCU_FG_TEXT = CommonCodeUtil.getCodeName("G20201", (String) erpMap.get("DOCU_FG"));
        		erpMap.put("DOCU_FG_TEXT", DOCU_FG_TEXT);
                
				Double UNIT_AM = 0.0000;
				UNIT_AM = Double.parseDouble(getStringValue(erpMap, "UNIT_AM", "0.0000"));
				TT_UNIT_AM += UNIT_AM;
				String iss_num = getStringValue(erpMap, "ISU_DT", "") + "-" + getStringValue(erpMap, "ISU_SQ", "");
				erpMap.put("ISU_NUM", iss_num);
				for (HashMap<String, Object> gwMap : docList) {
					if (erpMap.get("CO_CD").toString( ).equals(gwMap.get("ERP_CO_CD").toString( )) && erpMap.get("GISU_DT").toString( ).equals(gwMap.get("ERP_GISU_DT").toString( )) && erpMap.get("GISU_SQ").toString( ).equals(gwMap.get("ERP_GISU_SQ").toString( ))) {
						erpMap.put("DOC_NUMBER", gwMap.get("DOC_NUMBER"));
						erpMap.put("DOC_TITLE", gwMap.get("DOC_TITLE"));
						erpMap.put("DOC_DRAFTER", gwMap.get("DOC_DRAFTER"));
						erpMap.put("DOC_WRITE", gwMap.get("DOC_WRITE"));
						erpMap.put("DOC_STATUS_NM", gwMap.get("DOC_STATUS_NM"));
						erpMap.put("DOCU_FG_TEXT", gwMap.get("DOCU_FG_TEXT"));
					}
				}
			}

			HashMap<String, Object> totalList = new HashMap<>();
			totalList.put("GISU_DT", "합계");
			totalList.put("UNIT_AM", TT_UNIT_AM);
			selectList.add(totalList);
			mv.addObject("selectList", selectList);
			mv.addObject("total_UNIT_AM", TT_UNIT_AM);
		}
		catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		mv.setViewName("jsonView");
		return mv;

	}

    /**
     * 
     * AcExDocListView doban7 2016. 11. 7.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Ac/G20/State/AcExDocListView.do")
    public ModelAndView AcExDocListView(@RequestParam Map<String, Object> paramMap) throws Exception {
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("param", paramMap);
        
        mv.setViewName("/ac/g20/state/AcExDocListView");
        return mv;
    }
	
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "/Ac/G20/State/getAcExDocList.do")
    public ModelAndView getAcExDocList(@RequestParam Map<String, Object> paramMap) throws Exception {
        
        ModelAndView mv = new ModelAndView();

        Map<String, Object> resultMap = null;

        LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        List<HashMap<String, String>> selectList = null;
        try {
            
            PaginationInfo paginationInfo = new PaginationInfo();
            int pageSize =  10;
            int page = 1 ;
            String temp = (String)paramMap.get("pageSize");
            if (!EgovStringUtil.isEmpty(temp )  ) {
                pageSize = Integer.parseInt(temp) ;
            }
            temp = (String)paramMap.get("page") ;
            if (!EgovStringUtil.isEmpty(temp )  ) {
                page = Integer.parseInt(temp) ;
            }
            
            
            paginationInfo.setPageSize(pageSize);
            paginationInfo.setCurrentPageNo(page);
            paramMap.put("loginVo", loginVO);
            paramMap.put("langCode", loginVO.getLangCode());

            resultMap = acG20StateService.getAcExDocList(paramMap, paginationInfo);
            selectList = (List<HashMap<String, String>>) resultMap.get("list");    
        } catch (Exception e) {
            resultMap = new HashMap<String,Object>();
            e.printStackTrace();
            LOG.error(e);    
        }

        for(int j = 0; selectList != null && j < selectList.size(); j++){
            String MGT_NM = selectList.get(j).get("MGT_NM").toString();
            try {
                MGT_NM = URLDecoder.decode(selectList.get(j).get("MGT_NM").toString(), "UTF-8");
            }
            catch(UnsupportedEncodingException e) {
                e.printStackTrace();
            } 
            selectList.get(j).put("MGT_NM", MGT_NM);
        }
        
        String delAuthor = "N";
        
        if ( CommonCodeSpecific.isG20ErpAuth(loginVO.selectUserAuthor()) ) {
            delAuthor = "Y";
        }
        
        resultMap.put("list", selectList);
//        if(loginVO.isUserAuthor("A001")){
//            systemAuthor = "Y";
//        }
        mv.addObject("delAuthor", delAuthor);
        mv.setViewName("jsonView");
        mv.addAllObjects(resultMap);    // data.result
        return mv;
    }	
	    
    /**
     * 
     * getAcExDocDetail doban7 2016. 11. 13.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/Ac/G20/State/getAcExDocDetail.do")    
    public ModelAndView getAcExDocDetail(@RequestParam Map<String, Object> paramMap) throws Exception { 
        
        List<HashMap<String, String>> selectList = null;

        LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        paramMap.put("loginVo", loginVO);
        paramMap.put("langCode", loginVO.getLangCode());
        
        try {
        	selectList = acG20StateService.getAcExDocDetail(paramMap);
        } catch (Exception e) {
            e.printStackTrace();
            LOG.error(e);
        }
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("selectList", selectList);
        mv.setViewName("jsonView");
                
        return mv;
        
    }
    
    @RequestMapping(value="/Ac/G20/State/delAcExDoc.do")    
    public ModelAndView delAcExDoc(@RequestParam Map<String, Object> paramMap, Abdocu_H abdocu_Tmp) throws Exception { 
        
        HashMap<String, Object> result = null;
        //String result = "NO"; 
        String DOCU_MODE = (String) paramMap.get("docu_mode");
        try {
        	
        	if(DOCU_MODE.equals("1")){ //결의서 삭제
        		conVo = GetConnection();
        		result = acG20StateService.delAcExDoc(abdocu_Tmp, conVo);
        		if( (int)result.get( "StatChk" ) == 0){
        			/* 전표 처리 되지 않은 결의서만 삭제 진행. */
        			acG20ExAppService.approvalReturn(abdocu_Tmp); //결재반려
        		}
        	}else{ // 품의서 삭제 
        		result = acG20StateService.delAcExDocConfer(abdocu_Tmp);
        	}
            
            
        } catch (Exception e) {
            e.printStackTrace();
            LOG.error(e);
        }
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("result", result);
        mv.setViewName("jsonView");
        return mv;
        
    }    
	
	/**
	 * 
	 * getGwConfigList doban7 2016. 10. 1.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	private HashMap<String, Object> getGwConfigList(HashMap<String, String> paraMap) throws Exception {

		HashMap<String, Object> codeMap = new HashMap<String, Object>();
		try {

			/** 보조비연동여부 공통코드에서 가져오기 **/
			String SubBizYN = CommonCodeUtil.getCodeName("G20301", "SUBBIZ_YN");
			if (!SubBizYN.equals("Y")) {
				//		    	mv.addObject("bizGovYn", "0" ) ;	
			}
			/** 충남 명세서 사용여부 2013-04-16 doban7 공통코드에서 가져오기 **/
			String StateUseYn = CommonCodeUtil.getCodeName("G20301", "001");
			/** 법인카드 승인내역 사용 옵션 **/
			String ACardUseYn = CommonCodeUtil.getCodeName("G20301", "002");

			codeMap.put("ACardUseYn", ACardUseYn);
			codeMap.put("StateUseYn", StateUseYn);
			codeMap.put("SubBizUseYn", SubBizYN);

			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			codeMap.put("payAuth", loginVO.isUserAuthor("ERP_PAYDATA"));
			codeMap.put("spendAuth", loginVO.isUserAuthor("ERP_SPEND"));

		}
		catch (Exception e) {
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			String exceptionAsStrting = sw.toString();
			LOG.error("Call by getGwConfigList  : " + exceptionAsStrting);
			throw new Exception(exceptionAsStrting);
		}
		return codeMap;
	}

	/**
	 * 품의/결의자 사용자 정보, 기수정보 select getErpUser doban7 2016. 9. 1.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private Map<String, Object> getErpUser(ConnectionVO conVo, HashMap<String, String> paraMap) {

		Map<String, Object> map = null;
		System.out.println("paraMap   : " + paraMap);
		try {
			map = acG20CodeService.getErpUserInfo(conVo, paraMap);
		}
		catch (Exception e) {
			map = new HashMap<String, Object>();
			e.printStackTrace();
			LOG.error(e);
		}
		return map;
	}

	/**
	 * getErpGisuInfo doban7 2016. 9. 5.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private HashMap<String, String> getErpGisuInfo(ConnectionVO conVo, Map<String, String> paraMap) {

		HashMap<String, String> gisuInfo = null;
		try {
			gisuInfo = acG20ExService.getErpGisuInfo(conVo, paraMap);
		}
		catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
			gisuInfo = new HashMap<String, String>();
		}
		return gisuInfo;
	}

	/**
	 * 
	 * getErpGisuInfo doban7 2016. 10. 28.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/State/getErpGisuInfo.do")
	public ModelAndView getErpGisuInfo(@RequestParam HashMap<String, String> paraMap) throws Exception {

		ModelAndView mv = new ModelAndView();

		conVo = GetConnection();
		HashMap<String, String> gisuInfo = getErpGisuInfo(conVo, paraMap);

		mv.addObject("gisuInfo", gisuInfo);
		mv.setViewName("jsonView");
		return mv;
	}

	private String getStringValue(Map<String, Object> map, String key, String val) {
		if (map.containsKey(key)) {
			if (map.get(key) != null) {
				val = String.valueOf(map.get(key));
			}
		}
		return val;
	}
	
	/**
     * 
     * AcExDocListView doban7 2016. 11. 7.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/Ac/G20/State/custAcExDocListView.do")
    public ModelAndView custAcExDocListView(@RequestParam Map<String, Object> paramMap) throws Exception {
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("param", paramMap);
        
        mv.setViewName("/ac/g20/state/custAcExDocListView");
        return mv;
    }
	
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "/Ac/G20/State/getCustAcExDocList.do")
    public ModelAndView getCustAcExDocList(@RequestParam Map<String, Object> paramMap) throws Exception {
        
        ModelAndView mv = new ModelAndView();

        Map<String, Object> resultMap = null;

        LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        List<HashMap<String, String>> selectList = null;
        try {
            
            PaginationInfo paginationInfo = new PaginationInfo();
            int pageSize =  10;
            int page = 1 ;
            String temp = (String)paramMap.get("pageSize");
            if (!EgovStringUtil.isEmpty(temp )  ) {
                pageSize = Integer.parseInt(temp) ;
            }
            temp = (String)paramMap.get("page") ;
            if (!EgovStringUtil.isEmpty(temp )  ) {
                page = Integer.parseInt(temp) ;
            }
            
            
            paginationInfo.setPageSize(pageSize);
            paginationInfo.setCurrentPageNo(page);
            paramMap.put("loginVo", loginVO);
            paramMap.put("langCode", loginVO.getLangCode());

            resultMap = acG20StateService.getAcExDocList(paramMap, paginationInfo);
            selectList = (List<HashMap<String, String>>) resultMap.get("list");    
        } catch (Exception e) {
            resultMap = new HashMap<String,Object>();
            e.printStackTrace();
            LOG.error(e);    
        }

        for(int j = 0; selectList != null && j < selectList.size(); j++){
            String MGT_NM = selectList.get(j).get("MGT_NM").toString();
            try {
                MGT_NM = URLDecoder.decode(selectList.get(j).get("MGT_NM").toString(), "UTF-8");
            }
            catch(UnsupportedEncodingException e) {
                e.printStackTrace();
            } 
            selectList.get(j).put("MGT_NM", MGT_NM);
        }
        
        String delAuthor = "N";
        
        if ( CommonCodeSpecific.isG20ErpAuth(loginVO.selectUserAuthor()) ) {
            delAuthor = "Y";
        }
        
        resultMap.put("list", selectList);
//        if(loginVO.isUserAuthor("A001")){
//            systemAuthor = "Y";
//        }
        mv.addObject("delAuthor", delAuthor);
        mv.setViewName("jsonView");
        mv.addAllObjects(resultMap);    // data.result
        return mv;
    }	

}
