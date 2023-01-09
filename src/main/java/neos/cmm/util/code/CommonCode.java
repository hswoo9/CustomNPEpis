package neos.cmm.util.code;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import admin.option.dao.OptionManageDAO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.code.service.impl.CommonCodeDAO;

@Controller
@RequestMapping(value="/cmm/system/")
public class CommonCode {
	
	@Resource(name = "CommonCodeDAO")
	private CommonCodeDAO commonCodeDAO;
	
	@Resource(name = "OptionManageDAO")
	private OptionManageDAO optionManageDAO;

	/**
	 * 코드 리스트 조회
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonCodeList.do")
	public ModelAndView getCodeList(String codeID) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getCodeListLang( codeID) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(Child)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeList.do")
	public ModelAndView getChildCodeList(String codeID) throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getChildCodeList( codeID) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 코드 리스트 조회(Child)
	 * @param codeID
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeListAll.do")
	public ModelAndView getChildCodeListAll() throws Exception {
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getChildCodeListAll( ) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}	
	

	/**
	 * 코드이름 조회
	 * @param codeId
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonCodeName.do")
	public ModelAndView getCodeName(String codeId, String code) throws Exception {
		ModelAndView mv = new ModelAndView();
		String codeName = CommonCodeUtil.getCodeName( codeId, code) ;
		mv.setViewName("jsonView");
		mv.addObject("codeName", codeName);
		return mv;
	}

	
	/**
	 * 코드이름 조회(Child)
	 * @param codeId
	 * @param code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("commonChildCodeName.do")
	public ModelAndView getChildCodeName(String codeId, String code) throws Exception {
		ModelAndView mv = new ModelAndView();
		String codeName = CommonCodeUtil.getChildCodeName( codeId, code) ;
		mv.setViewName("jsonView");
		mv.addObject("codeName", codeName);
		return mv;
	}
	
	/**
	 * 코드캐쉬 초기화
	 * @throws Exception
	 */
	@RequestMapping("commonCodeReBuild.do")
	public ModelAndView getCodeReBuild() throws Exception {
		ModelAndView mv =  null;
		try {
			mv = new ModelAndView();
			CommonCodeUtil.reBuild(commonCodeDAO) ;
			/*공통코드 초기화시 메신저조직도도 초기화한다.*/
//			getGrpUserGrp();
			mv.setViewName("jsonView");
			mv.addObject("errorCode", "0");
		}catch( Exception e ) {
			mv.addObject("errorCode", "1");
		}
		return mv;
	}
	
	@RequestMapping("OptionReBuild.do")
	public ModelAndView getOptionReBuild() throws Exception {
		ModelAndView mv =  null;
		try {
			mv = new ModelAndView();
			CommonCodeUtil.reBuildOption(optionManageDAO) ;
			mv.setViewName("jsonView");
			mv.addObject("errorCode", "0");
		}catch( Exception e ) {
			mv.addObject("errorCode", "1");
		}
		return mv;
	}

	/** 
	 * 전자결재 회사 옵션 전체 가져오기 
	 * getOptionList doban7 2016. 12. 22.
	 * @param compSeq
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getOptionList.do")
	public ModelAndView getOptionList(String compSeq) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	if(compSeq == null || compSeq.equals("")){
    		compSeq = loginVO.getCompSeq();
    	}
		ModelAndView mv = new ModelAndView();
		List<Map<String, String>> list = CommonCodeUtil.getOptionList(compSeq) ;
		mv.setViewName("jsonView");
		mv.addObject("list", list);
		return mv;
	}
	
	/**
	 * 옵션 value 가져오기 
	 * getOptionValue doban7 2016. 12. 22.
	 * @param compSeq
	 * @param iptionId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("getOptionValue.do")
	public ModelAndView getOptionValue(String optionId, String compSeq) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	if(compSeq == null || compSeq.equals("")){
    		if(loginVO != null) {
    			compSeq = loginVO.getCompSeq();	
    		}
    	}
		ModelAndView mv = new ModelAndView();
		String optionValue = CommonCodeUtil.getOptionValue( compSeq, optionId) ;
		mv.setViewName("jsonView");
		mv.addObject("optionValue", optionValue);
		return mv;
	}
}
