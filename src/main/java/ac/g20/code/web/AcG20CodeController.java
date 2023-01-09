package ac.g20.code.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.code.sercive.AcG20CodeService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @title AcCodeiCubeController.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */

@Controller
public class AcG20CodeController {

	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(AcG20CodeController.class);
	
	@Resource(name ="AcCommonService")
	AcCommonService acCommonService;
	
	@Resource(name ="AcG20CodeService")
	AcG20CodeService acG20CodeService;
			
	private ConnectionVO conVo	= new ConnectionVO();
	
	/** 
	 * GetConnection doban7 2016. 9. 1.
	 * @return
	 */
	private ConnectionVO GetConnection() throws Exception{
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		return acCommonService.acErpSystemInfo(param);
	}

	/**
	 * ERP 회사코드
	 * getCO_CD doban7 2016. 9. 1.
	 * @return
	 */
	private String getCO_CD() {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpCoCd();
	}
	
	/**
	 * ERP 사원코드
	 * getEMP_CD doban7 2016. 9. 1.
	 * @return
	 */
	private String getEMP_CD() {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpEmpCd();
	}
	
	/** 
	 * 언어정보 
	 * getLANGKIND doban7 2016. 9. 1.
	 * @return
	 */
	private String getLANGKIND() {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getLangCode();
	}	
	
	/**
	 * 예산회계단위 리스트 조회
	 * getErpDIVList doban7 2016. 9. 5.
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpDIVList.do", method = RequestMethod.POST)
	public ModelAndView getErpDIVList(@RequestParam HashMap<String, String> paraMap, HttpServletRequest request) throws Exception {
		
		conVo = GetConnection();
		
		if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
	        paraMap.put("CO_CD", getCO_CD());
		}

		if(paraMap.get("BASE_DT") == null || paraMap.get("BASE_DT").equals("")){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String BASE_DT = sdf.format(new Date());
	        paraMap.put("BASE_DT", BASE_DT);
		}
		
		paraMap.put("LANGKIND", getLANGKIND());
		List<HashMap<String, String>> selectList = null;

		try {
			selectList = acG20CodeService.getErpDIVList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}

	/**
	 * 사원조회 
	 * getErpUserList doban7 2016. 9. 5.
	 * @param paraMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpUserList.do", method = RequestMethod.POST)
	public ModelAndView getErpUserList(@RequestParam HashMap<String, String> paraMap, HttpServletRequest request) throws Exception {
		
		conVo = GetConnection();
		
		if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
	        paraMap.put("CO_CD", getCO_CD());
		}

		paraMap.put("EMP_CD", null);
		paraMap.put("EMP_NM", null);
		
		paraMap.put("LANGKIND", getLANGKIND());
		List<HashMap<String, String>> selectList = null;

		try {
			selectList = acG20CodeService.getErpUserList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	

	/**
	 * 프로젝트 조회
	 * getErpProjectList doban7 2016. 9. 5.
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpMgtList.do", method = RequestMethod.POST)
	public ModelAndView getErpMgtList(@RequestParam Map<String, String> paraMap , HttpServletRequest request) throws Exception {
	    
		conVo = GetConnection();
		
        if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
		paraMap.put("LANGKIND", getLANGKIND());
		List<HashMap<String, String>> selectList = null;

		try {
			if("1".equals(paraMap.get("FG_TY"))){ /* 부서예산 */
				selectList = acG20CodeService.getErpMgtDeptList(conVo, paraMap);
				
				for ( HashMap<String, String> map : selectList ) {
					map.put( "PJT_CD", map.get( "DEPT_CD" ) );
					map.put( "PJT_NM", map.get( "DEPT_NM" ) );
				}
			}
			else{    //프로젝트예산
				selectList = acG20CodeService.getErpMgtPjtList(conVo, paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 하위사업 조회
	 * getErpBottom_cdList doban7 2016. 9. 5.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpAbgtBottomList.do", method = RequestMethod.POST)
	public ModelAndView getErpAbgtBottomList(@RequestParam Map<String, String> paraMap) throws Exception{
		conVo = GetConnection();

		if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
		paraMap.put("LANGKIND", getLANGKIND());
		List<HashMap<String, String>> selectList = null;

		try {
			selectList = acG20CodeService.getErpAbgtBottomList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 입출금계좌조회
	 * getBankTradeList doban7 2016. 9. 5.
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpBTRList.do", method = RequestMethod.POST)
	public ModelAndView getErpBTRList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpBTRList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	/**
	 * 
	 * getErpBudgetList doban7 2016. 9. 7.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpBudgetList.do", method = RequestMethod.POST)
	public ModelAndView getErpBudgetList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
		List<HashMap<String, String>> bgtList = null;
		List<HashMap<String, String>> nameList = null;
		try {
			bgtList = acG20CodeService.getErpBudgetList(conVo, paraMap);
			nameList = acG20CodeService.getErpBudgetNameList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", bgtList);
		mv.addObject("nameList", nameList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 
	 * getErpTradeList doban7 2016. 9. 7.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpTradeList.do", method = RequestMethod.POST)
	public ModelAndView getErpTradeList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
	    paraMap.put("TR_CD", "");
	    paraMap.put("TYPE", "");
	    paraMap.put("DETAIL_TYPE", paraMap.get("detail_type"));
	    paraMap.put("LANGKIND", getLANGKIND());
	    
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpTradeList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	
	/**
	 * 사용자 금융기관, 계좌번호 예금주 조회
	 * getErpBankList 2016. 9. 22.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings ( "finally" )
	@RequestMapping(value = "/Ac/G20/Code/getErpEmpBankTrade.do", method = RequestMethod.POST)
	public ModelAndView getErpEmpBankTrade(@RequestParam Map<String, String> paraMap) throws Exception{
		conVo = GetConnection();
		List<HashMap<String, String>> selectList = null;
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		try {
			if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
				throw new Exception("선택된 사원의 회사코드를 찾을 수 없습니다.");
	        }
		    if(paraMap.get("EMP_CD") == null || paraMap.get("EMP_CD").equals("")){
		    	throw new Exception("선택된 사원의 사원코드를 찾을 수 없습니다.");
	        }

		    paraMap.put("LANGKIND", getLANGKIND());	
			selectList = acG20CodeService.getErpEmpBankTrade(conVo, paraMap);
			mv.addObject( "isSuccess", true );
			mv.addObject("selectList", selectList);
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject( "isSuccess", false );
			mv.addObject( "commonMsg", e.getMessage( ) );
	    	mv.addObject( "selectList", null);
		}finally{
			return mv;	
		}
	}
	
	
	/**
	 * 금융기관 조회
	 * getErpBankList doban7 2016. 9. 22.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpBankList.do", method = RequestMethod.POST)
	public ModelAndView getErpBankList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
	    
	    paraMap.put("BANK_CD", "");
	    paraMap.put("BANK_NM", "");
	    paraMap.put("LANGKIND", getLANGKIND());
		
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpBankList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	/**
	 * 사원조회
	 * getErpEmpList doban7 2016. 9. 22.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpEmpList.do", method = RequestMethod.POST)
	public ModelAndView getErpEmpList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
	    
	    paraMap.put("LANGKIND", getLANGKIND());
		
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpEmpList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}		
	
	/**
	 * 기타소득자
	 * getErpHpmeticList doban7 2016. 9. 22.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpHpmeticList.do", method = RequestMethod.POST)
	public ModelAndView getErpHpmeticList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
	    
	    paraMap.put("LANGKIND", getLANGKIND());
		
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpHpmeticList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	     
	
	/**
	 * 사업소득자
	 * getErpHpmeticList doban7 2016. 9. 26.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Code/getErpHincomeList.do", method = RequestMethod.POST)
	public ModelAndView getErpHincomeList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
	    
	    paraMap.put("LANGKIND", getLANGKIND());
		
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpHincomeList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("selectList", selectList);
		mv.setViewName("jsonView");
		return mv;
	}	     

	/**
	 * 소득구분 코드
	 * getErpEtcIncomeList doban7 2016. 10. 6.
	 * @param request
	 * @return
	 * @throws Exception 
	 */
    @RequestMapping(value = "/Ac/G20/Code/getErpEtcIncomeList.do", method = RequestMethod.POST)
	public ModelAndView getErpEtcIncomeList(@RequestParam Map<String, String> paraMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		conVo = GetConnection();
		if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
		    paraMap.put("CO_CD", getCO_CD());
		}
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20CodeService.getErpEtcIncomeList(conVo, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}

		mv.setViewName("jsonView");
		mv.addObject("selectList", selectList);

		return mv;

	}

}
