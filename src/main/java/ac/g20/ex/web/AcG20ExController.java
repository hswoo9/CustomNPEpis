package ac.g20.ex.web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.common.service.CommonService;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.code.sercive.AcG20CodeService;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.vo.ACardVO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_D;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import ac.g20.ex.vo.Abdocu_TD;
import ac.g20.ex.vo.Abdocu_TD2;
import ac.g20.ex.vo.Abdocu_TH;
import ac.g20.ex.vo.PayDataVO;
import admin.form.service.FormManageService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * @title ExiCubeManageController.java
 * @author doban7
 *
 * @date 2016. 9. 1.
 */
@Controller
public class AcG20ExController {

	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger( AcG20ExController.class );
	@Resource ( name = "AcCommonService" )
	AcCommonService acCommonService;
	@Resource ( name = "AcG20ExService" )
	AcG20ExService acG20ExService;
	@Resource ( name = "AcG20CodeService" )
	AcG20CodeService acG20CodeService;
	@Resource ( name = "FormManageService" )
	FormManageService formManageService;
	private ConnectionVO conVo = new ConnectionVO( );

	/**
	 * GetConnection doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private ConnectionVO GetConnection ( ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>( );
		param.put( "loginVO", loginVO );
		return acCommonService.acErpSystemInfo( param );
	}

	@RequestMapping ( value = "/Ac/G20/Ex/AcExDocForm.do", method = RequestMethod.GET )
	public String AcExDocForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject( "params", requestMap );
		if ( !requestMap.containsKey( "mode" ) ) {
			requestMap.put( "mode", "0" );
		}
		if ( requestMap.get( "mode" ).equals( "1" ) ) {
			return "forward:/Ac/G20/Ex/AcExResDocForm.do";
		}
		return "forward:/Ac/G20/Ex/AcExConsDocForm.do";
	}

	/**
	 * G20 품의서 작성 팝업
	 * AcExConsDocForm doban7 2016. 9. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/AcExConsDocForm.do", method = RequestMethod.GET )
	public ModelAndView AcExConsDocForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/AcExConsDocFormPop" );
		// mv.setViewName( "/ac/g20/ex/Popup/AcExConsDocFormPop2" );
		return mv;
	}
	
	/**
	 * G20 결의서 작성 팝업
	 * AcExResDocForm doban7 2016. 9. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/AcExResDocForm.do", method = RequestMethod.GET )
	public ModelAndView AcExResDocForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "1" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/AcExResDocFormPop" );
		return mv;
	}

	@RequestMapping ( "/Ac/G20/Ex/AcExDocInit.do" )
	public ModelAndView AcExDocInit ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu, @RequestParam HashMap<String, Object> requestMap ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "jsonView" );
		/*
		 * 0 : 품의1 : 결의
		 */
		String mode = "0";
		//		String modeText = "";//
		String template_key = "";/* 양식 키 */
		//		String diKeyCode = "";/* 문서 키코드 */
		String abdocu_no_reffer = "";/* 참조 키코드 */
		if ( requestMap.containsKey( "template_key" ) ) {
			template_key = (String) requestMap.get( "template_key" );
		}
		if ( requestMap.containsKey( "mode" ) ) {
			mode = (String) requestMap.get( "mode" );
		}
		if ( "0".equalsIgnoreCase( mode ) ) {
			mode = "0";
		}
		else {
			mode = "1";
		}
		if ( getCO_CD( ) == null || getEMP_CD( ) == null ) { //연동된 회사코드, 사번 확인
			mv.addObject( "resultValue", "empty" );
			return mv;
		}
		Abdocu_H resultAbdocu = null;
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		//        List<HashMap<String, Object>> erpgisu = null;
		conVo = GetConnection( );
		// ERP 설정 파일 
		HashMap<String, String> paraMap = new HashMap<String, String>( );
		paraMap.put( "CO_CD", getCO_CD( ) );
		paraMap.put( "EMP_CD", getEMP_CD( ) );
		paraMap.put( "LANGKIND", getLANGKIND( ) );
		/*
		 * G20 시스템 환경설정 데이터 가져오기
		 * 조회구분 예산 , MODULE_CD = 4
		 */
		List<HashMap<String, String>> erpConfig = getErpConfigList( conVo, paraMap );
		mv.addObject( "erpConfig", JSONArray.fromObject( erpConfig ) );
		mv.addObject( "gwConfig", getGwConfigList( paraMap ) );
		Map<String, Object> erpUserInfo = acG20CodeService.getErpUserInfo( conVo, paraMap );
		getErpUser( conVo, paraMap );
		if ( erpUserInfo.get( "erpuser" ) == null ) { // 연동된 회사코드 , 사번 확인
			mv.addObject( "resultValue", "notExist" );
			return mv;
		}
		//시스템시간 가져오기 
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyy-MM-dd" );
		String date = dateFormat.format( new Date( ) );
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		//        if (erpUserInfo.containsKey("erpgisu")) {
		//            erpgisu = (List<HashMap<String, Object>>) erpUserInfo.get("erpgisu");
		//        }
		if ( erpuser == null ) {
			erpuser = new HashMap<String, String>( );
		}
		System.out.println( erpuser );
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		//        resultAbdocu.setTmp_dept_cd(erpuser.get("DEPT_CD"));
		//        resultAbdocu.setTmp_dept_nm(erpuser.get("DEPT_NM"));
		//        resultAbdocu.setTmp_emp_cd(erpuser.get("EMP_CD"));
		//        resultAbdocu.setTmp_emp_nm(erpuser.get("KOR_NM"));
		resultAbdocu.setDocu_mode( mode );
		resultAbdocu.setAbdocu_no( abdocu.getAbdocu_no( ) );
		resultAbdocu.setErp_gisu_dt( date );
		//        resultAbdocu.setErpgisu(erpgisu);
		//품의/결의종류를 가져온다.
		Map<String, Object> formInfo = GetFormInfo( template_key );
		if ( formInfo == null ) {
			mv.addObject( "resultValue", "notTempKey" );
			return mv;
		}
		String CHILDCODE = (String) formInfo.get( "CHILDCODE" );
		String CHILDCODEDETAIL = (String) formInfo.get( "CHILDCODEDETAIL" );
		String C_TINAME = (String) formInfo.get( "C_TINAME" );
		resultAbdocu.setDocu_fg_text( CommonCodeUtil.getChildCodeName( CHILDCODE, CHILDCODEDETAIL ) );
		resultAbdocu.setDocu_fg( CHILDCODEDETAIL );
		mv.addObject( "C_TINAME", C_TINAME );
		//        JSONArray jsonArray = JSONArray.fromObject(erpgisu);
		//        mv.addObject("erpgisu", jsonArray);
		mv.addObject( "abdocu", resultAbdocu );
		// Erp 권한 정보
		//        HashMap<String, String> permissionResult = getErpPermission(conVo,  paraMap);
		//        mv.addObject("permissionResult",JSONObject.fromObject(permissionResult));
		// Erp 기타소득 과세율정보
		HashMap<String, String> taxPercent = getErpTaxConifg( conVo, paraMap );
		mv.addObject( "taxRate", JSONObject.fromObject( taxPercent ) );
		//        mv.addObject("focus", focus);
		mv.addObject( "returnValue", "" );
		mv.addObject( "groupSeq", this.getGroupSeq( ) );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/Ac/G20/Ex/AcExDocInfo.do" )
	public ModelAndView AcExDocInfo ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu, @RequestParam HashMap<String, Object> requestMap ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		//		/*
		//		 * 0 : 품의1 : 결의
		//		 */
		//		String mode = "0";
		//		String modeText = "";//
		String template_key = "";/* 양식 키 */
		//		String diKeyCode = "";/* 문서 키코드 */
		//		String abdocu_no_reffer = "";/* 참조 키코드 */
		if ( requestMap.containsKey( "template_key" ) ) {
			template_key = (String) requestMap.get( "template_key" );
		}
		//		
		//		if (requestMap.containsKey("mode")) {
		//			mode = (String) requestMap.get("mode");
		//		}
		//		if(getCO_CD() == null || getEMP_CD() == null){  //연동된 회사코드, 사번 확인
		//		    mv.addObject("resultValue", "empty");
		//			return mv;
		//		}
		Abdocu_H resultAbdocu = null;
		Map<String, String> docu = new HashMap<String, String>( );
		HashMap<String, String> param = new HashMap<String, String>( );
		conVo = GetConnection( );
		// ERP 설정 파일 
		HashMap<String, String> paraMap = new HashMap<String, String>( );
		paraMap.put( "CO_CD", getCO_CD( ) );
		paraMap.put( "EMP_CD", getEMP_CD( ) );
		paraMap.put( "LANGKIND", getLANGKIND( ) );
		if ( abdocu.getAbdocu_no( ) != null ) { /* 조회모드 */
			resultAbdocu = getAbdocuH( abdocu );
			if ( resultAbdocu == null || resultAbdocu.getAbdocu_no( ) == null || resultAbdocu.getAbdocu_no( ).equals( "0" ) ) {
				mv.addObject( "resultValue", "empty" ); // 데이저 조회 
			}
			param.put( "CO_CD", resultAbdocu.getErp_co_cd( ) );
			param.put( "EMP_CD", resultAbdocu.getErp_emp_cd( ) );
			/*
			 * G20 시스템 환경설정 데이터 가져오기
			 */
			List<HashMap<String, String>> erpConfig = getErpConfigList( conVo, paraMap );
			mv.addObject( "erpConfig", erpConfig );
		}
		mv.addObject( "gwConfig", getGwConfigList( paraMap ) );
		//품의/결의종류를 가져온다.
		Map<String, Object> formInfo = GetFormInfo( template_key );
		if ( formInfo == null ) {
			mv.addObject( "resultValue", "notTempKey" );
			return mv;
		}
		String CHILDCODE = (String) formInfo.get( "CHILDCODE" );
		String CHILDCODEDETAIL = (String) formInfo.get( "CHILDCODEDETAIL" );
		String C_TINAME = (String) formInfo.get( "C_TINAME" );
		docu.put( "name", CommonCodeUtil.getChildCodeName( CHILDCODE, CHILDCODEDETAIL ) );
		docu.put( "code", CHILDCODEDETAIL );
		mv.addObject( "C_TINAME", C_TINAME );
		//        HashMap<String, String> permissionResult = getErpPermission(conVo,  paraMap);
		//        mv.addObject("permissionResult",JSONObject.fromObject(permissionResult));
		mv.addObject( "abdocu", resultAbdocu );
		HashMap<String, String> taxPercent = getErpTaxConifg( conVo, paraMap );
		mv.addObject( "taxRate", JSONObject.fromObject( taxPercent ) );
		mv.addObject( "groupSeq", this.getGroupSeq( ) );
		mv.addObject( "returnValue", "" );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * GetFormInfo doban7 2016. 9. 2.
	 * 
	 * @param template_key
	 * @return
	 */
	private Map<String, Object> GetFormInfo ( String template_key ) throws Exception {
		Map<String, Object> resultMap = null;
		try {
			HashMap<String, String> formMap = new HashMap<String, String>( );
			formMap.put( "c_tikeycode", template_key );
			resultMap = (Map<String, Object>) formManageService.getFormInfo( formMap ).get( "result" );
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by GetFormInfo  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		return resultMap;
	}

	/**
	 * GetTaxConifg doban7 2016. 9. 2.
	 * 
	 * @param conVo
	 * @param param
	 * @return
	 */
	private HashMap<String, String> getErpTaxConifg ( ConnectionVO conVo, HashMap<String, String> param ) throws Exception {
		HashMap<String, String> resultMap = null;
		try {
			resultMap = acG20ExService.getErpTaxConifg( conVo, param );
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by GetTaxConifg.do  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		return resultMap;
	}

	//	
	//	/** 
	//	 * getErpPermission doban7 2016. 9. 21.
	//	 * @param conVo
	//	 * @param paraMap
	//	 * @return
	//	 * @throws Exception 
	//	 */
	//	private HashMap<String, String> getErpPermission(ConnectionVO conVo, HashMap<String, String> paraMap) throws Exception {
	//		HashMap<String, String> returnRresult = null;
	//		
	//        try {
	//        	returnRresult = acG20ExService.getErpPermission(conVo, paraMap);
	//        	
	//        } catch (Exception e) {
	//			StringWriter sw = new StringWriter();
	//		    e.printStackTrace(new PrintWriter(sw));
	//		    String exceptionAsStrting = sw.toString();			
	//		    LOG.error("Call by GetTaxConifg.do  : " + exceptionAsStrting);
	//		    throw new Exception(exceptionAsStrting);
	//        }
	//		return returnRresult;
	//	}
	/**
	 * getAbdocu_TmpOne doban7 2016. 9. 1.
	 * 
	 * @param abdocu
	 * @return
	 */
	private Abdocu_H getAbdocuH ( Abdocu_H abdocu_H ) {
		Abdocu_H resultAbdocu = null;
		try {
			resultAbdocu = acG20ExService.getAbdocuH( abdocu_H );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		return resultAbdocu;
	}

	/**
	 * 
	 * getErpConfigList doban7 2016. 9. 2.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	private List<HashMap<String, String>> getErpConfigList ( ConnectionVO conVo, HashMap<String, String> paraMap ) throws Exception {
		List<HashMap<String, String>> list = null;
		try {
			list = acG20CodeService.getErpConfigList( conVo, paraMap );
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by getErpConfigList  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		return list;
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
	private HashMap<String, Object> getGwConfigList ( HashMap<String, String> paraMap ) throws Exception {
		HashMap<String, Object> codeMap = new HashMap<String, Object>( );
		try {
			/** 보조비연동여부 공통코드에서 가져오기 **/
			String SubBizYN = CommonCodeUtil.getCodeName( "G20301", "SUBBIZ_YN" );
			if ( !SubBizYN.equals( "Y" ) ) {
				//		    	mv.addObject("bizGovYn", "0" ) ;	
			}
			/** 충남 명세서 사용여부 2013-04-16 doban7 공통코드에서 가져오기 **/
			String ItemsUseYn = CommonCodeUtil.getCodeName( "G20301", "001" );
			/** 법인카드 승인내역 사용 옵션 **/
			String ACardUseYn = CommonCodeUtil.getCodeName( "G20301", "002" );
			codeMap.put( "ACardUseYn", ACardUseYn );
			codeMap.put( "ItemsUseYn", ItemsUseYn );
			codeMap.put( "SubBizUseYn", SubBizYN );
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			codeMap.put( "payAuth", loginVO.isUserAuthor( "ERP_PAYDATA" ) );
			codeMap.put( "spendAuth", loginVO.isUserAuthor( "ERP_SPEND" ) );
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by getGwConfigList  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		return codeMap;
	}

	/**
	 * 품의/결의자 사용자 정보, 기수정보 select
	 * getErpUser doban7 2016. 9. 1.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private Map<String, Object> getErpUser ( ConnectionVO conVo, HashMap<String, String> paraMap ) {
		Map<String, Object> map = null;
		System.out.println( "paraMap   : " + paraMap );
		try {
			map = acG20CodeService.getErpUserInfo( conVo, paraMap );
		}
		catch ( Exception e ) {
			map = new HashMap<String, Object>( );
			e.printStackTrace( );
			LOG.error( e );
		}
		return map;
	}

	/**
	 * ERP 회계 마감여부 체크
	 * checkBClose doban7 2016. 9. 7.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/chkErpBgtClose.do", method = RequestMethod.POST )
	public ModelAndView checkBClose ( @RequestParam Map<String, String> paraMap ) throws Exception {
		conVo = GetConnection( );
		if ( paraMap.get( "CO_CD" ) == null || paraMap.get( "CO_CD" ).equals( "" ) ) {
			paraMap.put( "CO_CD", getCO_CD( ) );
		}
		HashMap<String, String> selectList = null;
		try {
			selectList = acG20ExService.chkErpBgtClose( conVo, paraMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 결의서 헤더저장 (G20_Abdocu_H)
	 * setAbdocu doban7 2016. 9. 7.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuH.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuH ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_H ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_H.setInsert_id( loginVO.getUniqId( ) );
		abdocu_H.setModify_id( loginVO.getUniqId( ) );
		conVo = GetConnection( );
		Map<String, Object> map = null;
		if ( abdocu_H.getErp_co_cd( ) == null || abdocu_H.getErp_co_cd( ).equals( "" ) ) {
			abdocu_H.setErp_co_cd( getCO_CD( ) );
		}
		HashMap<String, String> paraMap = new HashMap<String, String>( );
		paraMap.put( "GISU_DT", abdocu_H.getErp_gisu_dt( ) );
		paraMap.put( "CO_CD", abdocu_H.getErp_co_cd( ) );
		HashMap<String, String> gisuInfo = getErpGisuInfo( conVo, paraMap );
		abdocu_H.setErp_gisu_from_dt( gisuInfo.get( "FROM_DT" ) );
		abdocu_H.setErp_gisu_to_dt( gisuInfo.get( "TO_DT" ) );
		abdocu_H.setErp_gisu( String.valueOf( gisuInfo.get( "GI_SU" ) ) );
		String result = null;
		try {
			if ( abdocu_H.getAbdocu_no( ).equals( "0" ) ) {
				map = acG20ExService.insertAbdocu_H( abdocu_H );
			}
			else {
				map = acG20ExService.updateAbdocu_H( abdocu_H );
			}
			result = (String) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	//	@RequestMapping(value = "/Ac/G20/Ex/budgetTradeInfoDel.do", method = RequestMethod.POST)
	//	public ModelAndView budgetTradeInfoDel(@ModelAttribute("abdocu") Abdocu_H abdocu) {
	//		ModelAndView mv = new ModelAndView();
	//		mv.setViewName("jsonView");
	//
	//		Map<String, Object> map = null;
	//		int result = 0;
	//
	//		try {
	//			map = acG20ExService.budgetTradeInfoDel(abdocu);
	//			result = (Integer) map.get("result");
	//		} catch (Exception e) {
	//			e.printStackTrace();
	//			LOG.error(e);
	//		}
	//
	//		mv.addObject("result", result);
	//
	//		return mv;
	//	}
	/**
	 * 결의서 예산 조회 G20_Abdocu_B
	 * getAbdocuB doban7 2016. 9. 7.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getAbdocuB_List.do", method = RequestMethod.POST )
	public ModelAndView getAbdocuB_List ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_H ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_B> selectList = null;
		try {
			selectList = acG20ExService.getAbdocuB_List( abdocu_H );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * Erp 예산정보 가져오기
	 * getErpBudgetInfo doban7 2016. 9. 7.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getBudgetInfo.do", method = RequestMethod.POST )
	public ModelAndView getBudgetInfo ( @RequestParam Map<String, String> paraMap ) throws Exception {
		conVo = GetConnection( );
		if ( paraMap.get( "CO_CD" ) == null || paraMap.get( "CO_CD" ).equals( "" ) ) {
			paraMap.put( "CO_CD", getCO_CD( ) );
		}
		paraMap.put( "LANGKIND", getLANGKIND( ) );
		HashMap<String, String> result = new HashMap<String, String>( );
		try {
			result = acG20ExService.getBudgetInfo( conVo, paraMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 예산정보 저장 G20_Abdocu_B
	 * setBudgetInfo doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuB.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuB ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_B.setInsert_id( loginVO.getUniqId( ) );
		abdocu_B.setModify_id( loginVO.getUniqId( ) );
		Map<String, Object> map = null;
		String result = null;
		try {
			if ( abdocu_B.getAbdocu_b_no( ).equals( "0" ) ) {
				map = acG20ExService.insertAbdocu_B( abdocu_B );
			}
			else {
				map = acG20ExService.updateAbdocu_B( abdocu_B );
			}
			result = (String) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 결의서 채주정보 가져오기 G20_Abdocu_T
	 * getTradeList doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getAbdocuT_List.do", method = RequestMethod.POST )
	public ModelAndView getAbdocuT_List ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_T> selectList = null;
		try {
			selectList = acG20ExService.getAbdocuT_List( abdocu_B );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}

	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuT.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_T.setInsert_id( loginVO.getUniqId( ) );
		abdocu_T.setModify_id( loginVO.getUniqId( ) );
		Map<String, Object> map = null;
		String result = null;
		Abdocu_B abdocu_B = null;
		try {
			if ( abdocu_T.getAbdocu_t_no( ).equals( "0" ) ) {
				map = acG20ExService.insertAbdocu_T( abdocu_T );
			}
			else {
				map = acG20ExService.updateAbdocu_T( abdocu_T );
			}
			result = (String) map.get( "result" );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 
	 * delAbdocuH doban7 2016. 9. 29.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuH.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuH ( @ModelAttribute ( "abdocu_H" ) Abdocu_H abdocu_H ) {
		ModelAndView mv = new ModelAndView( );
		//		Map<String, Object> map = null;
		Integer result = 0;
		try {
			result = acG20ExService.deleteAbdocu_H( abdocu_H );
			// 	        result = (Integer) map.get("result");
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 
	 * delAbdocuB doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuB.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuB ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		try {
			map = acG20ExService.deleteAbdocu_B( abdocu_B );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addAllObjects( map );
		return mv;
	}

	/**
	 * 
	 * delAbdocuT doban7 2016. 9. 7.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuT.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T ) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		Integer result = null;
		try {
			map = acG20ExService.deleteAbdocu_T( abdocu_T );
			result = (Integer) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 품의/결의 올릴때 예산 초과 밸리데이션
	 * 
	 * @param
	 * @throws Exception
	 */
	//	@RequestMapping(value = "/neos/erp/g20/approvalValidation.do", method = RequestMethod.POST)
	@RequestMapping ( value = "/Ac/G20/Ex/approvalValidation.do", method = RequestMethod.POST )
	public ModelAndView approvalBudgetOverValidation ( Abdocu_B abdocu_B ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		conVo = GetConnection( );
		HashMap<String, String> paraMap = new HashMap<String, String>( );
		if ( abdocu_B.getErp_co_cd( ) == null ) {
			paraMap.put( "CO_CD", abdocu_B.getErp_co_cd( ) );
		}
		Map<String, Object> map = null;
		Double result = -1.0;
		String ctlFg = ""; 
		try {
			map = acG20ExService.approvalValidation( conVo, abdocu_B );
			result = Double.parseDouble( map.get( "result" ).toString( ) );
			ctlFg = map.get( "ctlFg" ).toString( );
		}
		catch ( Exception e ) {
			map = new HashMap<String, Object>( );
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		mv.addObject( "ctlFg", ctlFg );
		mv.addObject( "trCnt", map.get("trCnt") );
		return mv;
	}

	/**
	 * getErpGisuInfo doban7 2016. 9. 5.
	 * 
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	private HashMap<String, String> getErpGisuInfo ( ConnectionVO conVo, Map<String, String> paraMap ) {
		HashMap<String, String> gisuInfo = null;
		try {
			gisuInfo = acG20ExService.getErpGisuInfo( conVo, paraMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			gisuInfo = new HashMap<String, String>( );
		}
		return gisuInfo;
	}

	/**
	 * 그룹 코드
	 * getCO_CD doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getGroupSeq ( ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getGroupSeq( );
	}
	/**
	 * ERP 회사코드
	 * getCO_CD doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getCO_CD ( ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpCoCd( );
	}

	/**
	 * ERP 사원코드
	 * getEMP_CD doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getEMP_CD ( ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getErpEmpCd( );
	}

	/**
	 * 언어정보
	 * getLANGKIND doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private String getLANGKIND ( ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		return loginVO.getLangCode( );
	}

	/**
	 * 기타소득자선택 후 기존에 선택한 소득구분값을
	 * getETCDUMMY1 doban7 2016. 10. 6.
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getETCDUMMY1.do", method = RequestMethod.POST )
	public ModelAndView getETCDUMMY1 ( @RequestParam HashMap<String, String> paraMap ) throws Exception {
		conVo = GetConnection( );
		if ( paraMap.get( "CO_CD" ) == null || paraMap.get( "CO_CD" ).equals( "" ) ) {
			paraMap.put( "CO_CD", getCO_CD( ) );
		}
		paraMap.put( "EMP_CD", getEMP_CD( ) );
		HashMap<String, String> selectList = new HashMap<String, String>( );
		HashMap<String, String> etcResult = new HashMap<String, String>( );
		String ETCDUMMY1 = paraMap.get( "ETCDUMMY1" );
		String DATA_CD = paraMap.get( "DATA_CD" );
		String TR_CD = paraMap.get( "TR_CD" );
		try {
			if ( !TR_CD.equals( "empty" ) ) {
				etcResult = acG20ExService.getETCDUMMY1( paraMap );
				if ( etcResult != null ) {
					if ( (ETCDUMMY1 == null || ETCDUMMY1.equals( "" )) && etcResult.get( "ETCDUMMY1" ) != null ) {
						ETCDUMMY1 = etcResult.get( "ETCDUMMY1" ).toString( );
					}
					if ( (DATA_CD == null || DATA_CD.equals( "" )) && etcResult.get( "ETCDATA_CD" ) != null ) {
						DATA_CD = etcResult.get( "ETCDATA_CD" ).toString( );
					}
				}
			}
			if ( ETCDUMMY1 != null && !ETCDUMMY1.equals( "" ) ) {
				paraMap.put( "ETCDUMMY1", ETCDUMMY1 );
				paraMap.put( "DATA_CD", DATA_CD );
				selectList = acG20ExService.getErpETCDUMMY1_Info( paraMap, conVo );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 소득구분 코드 입력
	 * getETCDUMMY1Info doban7 2016. 10. 6.
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getErpETCDUMMY1_Info.do", method = RequestMethod.POST )
	public ModelAndView getErpETCDUMMY1_Info ( @RequestParam HashMap<String, String> paraMap ) throws Exception {
		conVo = GetConnection( );
		if ( paraMap.get( "CO_CD" ) == null || paraMap.get( "CO_CD" ).equals( "" ) ) {
			paraMap.put( "CO_CD", getCO_CD( ) );
		}
		HashMap<String, String> selectList = new HashMap<String, String>( );
		String ETCDUMMY1 = paraMap.get( "ETCDUMMY1" );
		String DATA_CD = paraMap.get( "DATA_CD" );
		if ( DATA_CD.equals( "" ) ) {
			DATA_CD = "G";
		}
		try {
			if ( ETCDUMMY1 != null && !ETCDUMMY1.equals( "" ) ) {
				paraMap.put( "ETCDUMMY1", ETCDUMMY1 );
				paraMap.put( "DATA_CD", DATA_CD );
				selectList = acG20ExService.getErpETCDUMMY1_Info( paraMap, conVo );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 원인행위 정보 저장
	 * setAbdocuCause doban7 2016. 10. 6.
	 * 
	 * @param abdocu
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuCause.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuCause ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu ) {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "jsonView" );
		Integer result = 0;
		try {
			result = acG20ExService.setAbdocuCause( abdocu );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		return mv;
	}

	/* ########################################### 참조품의서 관련 ############################################# */
	/**
	 * 참조품의서 리스트 팝업
	 * ReferConferPop doban7 2016. 10. 21.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/ReferConferPop.do" )
	public ModelAndView ReferConferPop ( @RequestParam HashMap<String, String> paramMap ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		conVo = GetConnection( );
		HashMap<String, String> gisuInfo = getErpGisuInfo( conVo, paramMap );
		paramMap.put( "FROM_DT", gisuInfo.get( "FROM_DT" ) );
		paramMap.put( "TO_DT", gisuInfo.get( "TO_DT" ) );
		mv.addObject( "param", paramMap );
		mv.setViewName( "/ac/g20/ex/SubPopup/AcExReferConferPop" );
		return mv;
	}

	/**
	 * 품의서 리스트 검색
	 * getReferConfer doban7 2016. 10. 19.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getReferConfer.do", method = RequestMethod.POST )
	public ModelAndView getReferConfer ( @RequestParam HashMap<String, String> paraMap ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put( "C_DIUSERKEY", loginVO.getUniqId( ) );
		paraMap.put( "OrgnztId", loginVO.getOrgnztId( ) );
		paraMap.put( "deptSeq", loginVO.getOrgnztId( ) );
		paraMap.put( "empSeq", loginVO.getUniqId( ) );
		paraMap.put( "langCode", loginVO.getLangCode( ) );
		String getConferType = CommonCodeUtil.getCodeName( "G20301", "GET_CONFER_TYPE" );
		paraMap.put( "getConferType", getConferType );
		if ( !paraMap.get( "searchText" ).equals( "" ) ) {
			paraMap.put( "searchText_encode", URLEncoder.encode( paraMap.get( "searchText" ), "UTF-8" ) );
		}
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20ExService.getReferConfer( paraMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		HashMap<String, String> t = null;
		for ( int i = 0, max = selectList.size( ); i < max; i++ ) {
			t = selectList.get( i );
			String MGT_NM = t.get( "MGT_NM" );
			try {
				t.put( "MGT_NM", URLDecoder.decode( MGT_NM, "UTF-8" ) );
				//System.out.println(MGT_NM + "::" + t.get("MGT_NM"));
				selectList.set( i, t );
			}
			catch ( Exception e ) {
				e.printStackTrace( );
			}
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 
	 * insertReferConfer doban7 2016. 9. 29.
	 * 
	 * @param abdocu_H
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertReferConfer.do", method = RequestMethod.POST )
	public ModelAndView insertReferConfer ( Abdocu_H abdocu_H ) throws Exception {
		Abdocu_H result = null;
		Map<String, Object> map = null;
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_H.setInsert_id( loginVO.getUniqId( ) );
		try {
			map = acG20ExService.insertReferConfer( abdocu_H );
			result = (Abdocu_H) map.get( "result" );
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by _EAAppDocW.do  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 품의잔액 조회
	 * getConferBalance doban7 2016. 9. 29.
	 * 
	 * @param abdocu_b
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getConferBalance.do", method = RequestMethod.POST )
	public ModelAndView getConferBalance ( Abdocu_B abdocu_b ) {
		String LEFT_AM = "";
		try {
			LEFT_AM = acG20ExService.getConferBalance( abdocu_b );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "LEFT_AM", LEFT_AM );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 예산 환원
	 * returnConferBudget doban7 2016. 10. 2.
	 * 
	 * @param abdocu_B
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/returnConferBudget.do", method = RequestMethod.POST )
	public ModelAndView returnConferBudget ( @RequestParam HashMap<String, String> paraMap ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put( "C_DIUSERKEY", loginVO.getUniqId( ) );
		paraMap.put( "OrgnztId", loginVO.getOrgnztId( ) );
		paraMap.put( "deptSeq", loginVO.getOrgnztId( ) );
		paraMap.put( "empSeq", loginVO.getUniqId( ) );
		paraMap.put( "langCode", loginVO.getLangCode( ) );
		//	    paraMap.put("CO_CD", getCO_CD());
		String getConferType = CommonCodeUtil.getCodeName( "G20301", "GET_CONFER_TYPE" );
		paraMap.put( "getConferType", getConferType );
		Map<String, Object> map = null;
		String result = "NO";
		int spendCnt = 0;
		try {
			map = acG20ExService.getReturnConferBudget( paraMap );
			result = (String) map.get( "result" );
			//			spendCnt = (Integer)map.get("spendCnt");
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.addObject( "spendCnt", spendCnt );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 참조품의 예산환원 취소
	 * 
	 * @param
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/returnConferBudgetRollBack.do", method = RequestMethod.POST )
	public ModelAndView returnConferBudgetRollBack ( @RequestParam HashMap<String, String> paraMap ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put( "C_DIUSERKEY", loginVO.getUniqId( ) );
		paraMap.put( "deptSeq", loginVO.getOrgnztId( ) );
		paraMap.put( "empSeq", loginVO.getUniqId( ) );
		paraMap.put( "langCode", loginVO.getLangCode( ) );
		Map<String, Object> map = null;
		String result = "NO";
		try {
			map = acG20ExService.returnConferBudgetRollBack( paraMap );
			result = (String) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/* ########################################### 법인카드 승인내역 ############################################# */
	/**
	 * 법인카드 팝업
	 * erpG20CoCardPop doban7 2016. 10. 1.
	 * 
	 * @param requestMap
	 * @param request
	 * @param erpG20CoCardVO
	 * @return
	 */
	@SuppressWarnings ( "deprecation" )
	@RequestMapping ( value = "/Ac/G20/Ex/ACardSunginPop.do" )
	public ModelAndView ACardSunginPop ( @RequestParam HashMap<String, Object> requestMap, @ModelAttribute ( "coCardVO" ) ACardVO aCardVO ) {
		ModelAndView mv = new ModelAndView( );
		SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd" );
		Date currentTime = new Date( );
		String ISS_DT_TO = formatter.format( currentTime );
		currentTime.setMonth( currentTime.getMonth( ) - 1 );
		String ISS_DT_FROM = formatter.format( currentTime );
		aCardVO.setISS_DT_FROM( ISS_DT_FROM );
		aCardVO.setISS_DT_TO( ISS_DT_TO );
		List<ACardVO> selectList = null;
		try {
			selectList = acG20ExService.getACardSungin_List( aCardVO );
			mv.addObject( "selectList", selectList );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "aCardVO", aCardVO );
		mv.addObject( "param", requestMap );
		mv.setViewName( "jsonView" );
		mv.setViewName( "/ac/g20/ex/SubPopup/AcExACardSunginPop" );
		return mv;
	}

	/**
	 * 법인카드리스트 가져오기 (권한체크)
	 * getACardList doban7 2016. 10. 2.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getACardList.do", method = RequestMethod.POST )
	public ModelAndView getACardList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		if ( requestMap.get( "erp_co_cd" ) == null || requestMap.get( "erp_co_cd" ).equals( "" ) ) {
			requestMap.put( "erp_co_cd", getCO_CD( ) );
		}
		requestMap.put( "LANGKIND", "KR" );
		requestMap.put("empSeq", loginVO.getUniqId());
		List<HashMap<String, String>> selectList = null;
		try {
			requestMap.put( "erpCompSeq", requestMap.get("erp_co_cd") );
        	requestMap.put( "compSeq", loginVO.getCompSeq( ) );
        	requestMap.put( "deptSeq", loginVO.getOrgnztId( ) );
        	requestMap.put( "empSeq", loginVO.getUniqId( ) );
			selectList = acG20ExService.getACardList( requestMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 법인카드 승인리스트
	 * getErpACardSunginList doban7 2016. 10. 2.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( "/Ac/G20/Ex/getErpACardSunginList.do" )
	public ModelAndView getErpACardSunginList ( @RequestParam HashMap<String, String> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		conVo = GetConnection( );
		List<HashMap<String, String>> selectList = null;
		if ( requestMap.get( "CO_CD" ) == null || requestMap.get( "CO_CD" ).equals( "" ) ) {
			requestMap.put( "CO_CD", getCO_CD( ) );
		}
		requestMap.put( "EMP_CD", getEMP_CD( ) );
		requestMap.put( "LANGKIND", "KR" );
		try {
			selectList = acG20ExService.getErpACardSunginList( requestMap, conVo );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 
	 * setACardSungin doban7 2016. 10. 3.
	 * 
	 * @param aCardVO
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setACardSungin.do", method = RequestMethod.POST )
	public ModelAndView setACardSungin ( @ModelAttribute ( "aCardVO" ) ACardVO aCardVO, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		aCardVO.setEmp_cd( getEMP_CD( ) );
		aCardVO.setErp_co_cd( getCO_CD() );
		if ( aCardVO.getErp_co_cd( ).equals( "" ) || aCardVO.getErp_co_cd( ) == null ) {
			aCardVO.setErp_co_cd( getCO_CD( ) );
		}
		Map<String, Object> map = null;
		int result = 0;
		Abdocu_B abdocu_B = null;
		try {
			map = acG20ExService.setACardSungin( aCardVO );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
			result = (Integer) map.get( "result" );
		}
		catch ( Exception e ) {
			map = new HashMap<String, Object>( );
			e.printStackTrace( );
			LOG.error( e );
			result = -1;
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		return mv;
	}

	/* ########################################### 여비명세서 POP ############################################# */
	/* 명세서 등록 */
	/**
	 * 명세서 팝업 띄우기
	 * ItemsFormPop doban7 2016. 10. 3.
	 * 
	 * @param requestMap
	 * @param abdocu_h
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/ItemsFormPop.do" )
	public ModelAndView ItemsFormPop ( @RequestParam HashMap<String, Object> requestMap, @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_h ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		//일반 명세서
		String forward = "/ac/g20/ex/SubPopup/AcExGoodsItemsFormPop";
		//여비명세서
		if ( abdocu_h.getDocu_fg( ).equals( "8" ) ) {
			forward = "/ac/g20/ex/SubPopup/AcExTravelItemsFormPop";
			try {
				/** 건강가정진흥원 출장신청 연동 사용여부 2015-01-26 doban7 공통코드에서 가져오기 **/
				String biztrip_link = CommonCodeUtil.getCodeName( "G20301", "BIZTRIP_LINK" );
				mv.addObject( "biztrip_link", biztrip_link );
				mv.addObject( "spendAuth", loginVO.isUserAuthor( "ERP_SPEND" ) );
				mv.addObject( "biztripAuth", loginVO.isUserAuthor( "ERP_BIZTRIP" ) );
				Abdocu_TH abdocu_th = acG20ExService.getAbdocuTH( abdocu_h );
				mv.addObject( "abdocu_th", abdocu_th );
			}
			catch ( Exception e ) {
				e.printStackTrace( );
				LOG.error( e );
			}
			mv.setViewName( "jsonView" );
		}
		else {
		}
		mv.addObject( "erp_co_cd", abdocu_h.getErp_co_cd( ) );
		mv.addObject( "abdocu_no", abdocu_h.getAbdocu_no( ) );
		mv.addObject( "abdocu", abdocu_h );
		mv.addObject( "param", requestMap );
		mv.setViewName( forward );
		return mv;
	}

	/**
	 * 명세서 총합계
	 * getItemsTotalAm doban7 2016. 10. 5.
	 * 
	 * @param requestMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getItemsTotalAm.do" )
	public ModelAndView getItemsTotalAm ( @ModelAttribute ( "abdocu_h" ) Abdocu_H abdocu_h ) {
		HashMap<String, String> result = null;
		try {
			result = acG20ExService.getItemsTotalAm( abdocu_h );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	/* ########################################### 여비명세서 등록 START ############################################# */

	/**
	 * 여비 명세서 상세(TD) 가져오기
	 * getAbdocuTD_List doban7 2016. 10. 3.
	 * 
	 * @param abdocu_h
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getAbdocuTD_List.do", method = RequestMethod.POST )
	public ModelAndView getAbdocuTD_List ( Abdocu_H abdocu_h, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_TD> selectList = null;
		try {
			selectList = acG20ExService.getAbdocuTD_List( abdocu_h );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}

	/**
	 * 여비 명세서 출장(TD2) 가져오기
	 * getAbdocuTD2_List doban7 2016. 10. 3.
	 * 
	 * @param abdocu_h
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getAbdocuTD2_List.do", method = RequestMethod.POST )
	public ModelAndView getAbdocuTD2_List ( Abdocu_H abdocu_h, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_TD2> selectList = null;
		try {
			selectList = acG20ExService.getAbdocuTD2_List( abdocu_h );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}

	/**
	 * 여비명세 헤더 저장
	 * setAbdocuTH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_th_Tmp
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuTH.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuTH ( @ModelAttribute ( "abdocu_th_Tmp" ) Abdocu_TH abdocu_th, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_th.setInsert_id( loginVO.getUniqId( ) );
		abdocu_th.setModify_id( loginVO.getUniqId( ) );
		if ( abdocu_th.getErp_co_cd( ) == null || abdocu_th.getErp_co_cd( ).equals( "" ) ) {
			abdocu_th.setErp_co_cd( getCO_CD( ) );
		}
		int abdocu_th_no = Integer.parseInt( abdocu_th.getAbdocu_th_no( ) );
		try {
			if ( abdocu_th_no > 0 ) {
				acG20ExService.updateAbdocu_TH( abdocu_th );
				mv.addObject( "result", abdocu_th.getAbdocu_th_no( ) );
			}
			else {
				Object result = acG20ExService.insertAbdocu_TH( abdocu_th );
				mv.addObject( "result", result );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			//            mv.addObject("result", 0);
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 여비명세서 헤더 삭제
	 * delAbdocuTH doban7 2016. 10. 3.
	 * 
	 * @param abdocu_Tmp
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuTH.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuTH ( Abdocu_TH abdocu_Tmp ) {
		ModelAndView mv = new ModelAndView( );
		int result = 0;
		try {
			result = acG20ExService.deleteAbdocu_TH( abdocu_Tmp );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 여비명세 상세 저장
	 * setAbdocuTD doban7 2016. 10. 3.
	 * 
	 * @param abdocu_td_Tmp
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuTD.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuTD ( @ModelAttribute ( "abdocu_td" ) Abdocu_TD abdocu_td, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		if ( abdocu_td.getErp_co_cd( ) == null || abdocu_td.getErp_co_cd( ).equals( "" ) ) {
			abdocu_td.setErp_co_cd( getCO_CD( ) );
		}
		int abdocu_td_no = Integer.parseInt( abdocu_td.getAbdocu_td_no( ) );
		try {
			if ( abdocu_td_no > 0 ) {
				acG20ExService.updateAbdocu_TD( abdocu_td );
				mv.addObject( "result", abdocu_td.getAbdocu_td_no( ) );
			}
			else {
				Object result = acG20ExService.insertAbdocu_TD( abdocu_td );
				mv.addObject( "result", result );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 여비명세 상세 삭제
	 * delAbdocuTD doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuTD.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuTD ( Abdocu_TD abdocu_td ) {
		ModelAndView mv = new ModelAndView( );
		int result = 0;
		try {
			result = acG20ExService.deleteAbdocu_TD( abdocu_td );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 여비명세 출장 저장
	 * setAbdocuTD2 doban7 2016. 10. 3.
	 * 
	 * @param abdocu_td2_Tmp
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuTD2.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuTD2 ( @ModelAttribute ( "abdocu_td2" ) Abdocu_TD2 abdocu_td2 ) {
		ModelAndView mv = new ModelAndView( );
		if ( abdocu_td2.getErp_co_cd( ) == null || abdocu_td2.getErp_co_cd( ).equals( "" ) ) {
			abdocu_td2.setErp_co_cd( getCO_CD( ) );
		}
		int abdocu_td2_no = Integer.parseInt( abdocu_td2.getAbdocu_td2_no( ) );
		try {
			if ( abdocu_td2_no > 0 ) {
				acG20ExService.updateAbdocu_TD2( abdocu_td2 );
				mv.addObject( "result", abdocu_td2.getAbdocu_td2_no( ) );
			}
			else {
				Object result = acG20ExService.insertAbdocu_TD2( abdocu_td2 );
				mv.addObject( "result", result );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 여비명세 출장 삭제
	 * delAbdocuTD2 doban7 2016. 10. 4.
	 * 
	 * @param abdocu_td2
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuTD2.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuTD2 ( Abdocu_TD2 abdocu_td2 ) {
		ModelAndView mv = new ModelAndView( );
		int result = 0;
		try {
			result = acG20ExService.deleteAbdocu_TD2( abdocu_td2 );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}
	/* ########################################### 여비명세서 등록 END ############################################# */

	/* ########################################### 물품명세서 등록 START ############################################# */
	/**
	 * 일반 명세서 리스트 가져오기
	 * getAbdocuD_List doban7 2016. 10. 4.
	 * 
	 * @param abdocu_h
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getAbdocuD_List.do", method = RequestMethod.POST )
	public ModelAndView getAbdocuD_List ( Abdocu_H abdocu_h, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_D> selectList = null;
		try {
			selectList = acG20ExService.getAbdocuD_List( abdocu_h );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}

	/**
	 * 물품명세 저장
	 * setAbdocuD doban7 2016. 10. 4.
	 * 
	 * @param abdocu_d
	 * @param request
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setAbdocuD.do", method = RequestMethod.POST )
	public ModelAndView setAbdocuD ( @ModelAttribute ( "abdocu_d" ) Abdocu_D abdocu_d, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_d.setInsert_id( loginVO.getUniqId( ) );
		abdocu_d.setModify_id( loginVO.getUniqId( ) );
		if ( abdocu_d.getErp_co_cd( ) == null || abdocu_d.getErp_co_cd( ).equals( "" ) ) {
			abdocu_d.setErp_co_cd( getCO_CD( ) );
		}
		int abdocu_d_no = Integer.parseInt( abdocu_d.getAbdocu_d_no( ) );
		try {
			if ( abdocu_d_no > 0 ) { //업데이트
				acG20ExService.updateAbdocu_D( abdocu_d );
				mv.addObject( "result", abdocu_d.getAbdocu_d_no( ) );
			}
			else { //신규등록
				Object result = acG20ExService.insertAbdocu_D( abdocu_d );
				mv.addObject( "result", result );
			}
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 물품 명세서 삭제
	 * delAbdocuD doban7 2016. 10. 4.
	 * 
	 * @param abdocu_d
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delAbdocuD.do", method = RequestMethod.POST )
	public ModelAndView delAbdocuD ( Abdocu_D abdocu_d ) {
		ModelAndView mv = new ModelAndView( );
		int result = 0;
		try {
			result = acG20ExService.deleteAbdocu_D( abdocu_d );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}
	/* ########################################### 물품명세서 등록 END ############################################# */

	/* ########################################### 급여자료 조회 AND ############################################# */
	/**
	 * 급여자료 선택팝업, 기존에 선택한 리스트도 불러온다.
	 * PayDataPop doban7 2016. 10. 21.
	 * 
	 * @return
	 */
	@SuppressWarnings ( "deprecation" )
	@RequestMapping ( value = "/Ac/G20/Ex/PayDataPop.do" )
	public ModelAndView PayDataPop ( @RequestParam HashMap<String, String> paraMap ) {
		ModelAndView mv = new ModelAndView( );
		SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd" );
		Date currentTime = new Date( );
		String PAY_DT_TO = formatter.format( currentTime );
		currentTime.setMonth( currentTime.getMonth( ) - 1 );
		String PAY_DT_FROM = formatter.format( currentTime );
		paraMap.put( "PAY_DT_FROM", PAY_DT_FROM );
		paraMap.put( "PAY_DT_TO", PAY_DT_TO );
		List<PayDataVO> selectList = null;
		try {
			selectList = acG20ExService.getThisPayDataList( paraMap );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "PAY_DT_TO", PAY_DT_TO );
		mv.addObject( "PAY_DT_FROM", PAY_DT_FROM );
		mv.addObject( "param", paraMap );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "/ac/g20/ex/SubPopup/AcExPayDataPop" );
		return mv;
	}

	/**
	 * ERP 급여데이터 가져온다.
	 * getErpPayData doban7 2016. 10. 24.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getErpPayData.do", method = RequestMethod.POST )
	public ModelAndView getErpPayData ( @RequestParam HashMap<String, Object> paraMap ) throws Exception {
		if ( paraMap.get( "CO_CD" ) == null || paraMap.get( "CO_CD" ).equals( "" ) ) {
			paraMap.put( "CO_CD", getCO_CD( ) );
		}
		conVo = GetConnection( );
		List<HashMap<String, Object>> selectList = null;/* 채주유형 */
		try {
			selectList = acG20ExService.getErpPayData( paraMap, conVo );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		for ( int j = 0; selectList != null && j < selectList.size( ); j++ ) {
			Double TPAY_AM = 0.0;
			Double INTX_AM = 0.0;
			Double RSTX_AM = 0.0;
			Double ETC_AM = 0.0;
			Double SUP_AM = 0.0;
			Double VAT_AM = 0.0;
			TPAY_AM = Double.parseDouble( selectList.get( j ).get( "TPAY_AM" ).toString( ) );
			INTX_AM = Double.parseDouble( selectList.get( j ).get( "INTX_AM" ).toString( ) );
			RSTX_AM = Double.parseDouble( selectList.get( j ).get( "RSTX_AM" ).toString( ) );
			ETC_AM = Double.parseDouble( selectList.get( j ).get( "ETC_AM" ).toString( ) );
			VAT_AM = INTX_AM + RSTX_AM + ETC_AM;
			SUP_AM = TPAY_AM - VAT_AM;
			selectList.get( j ).put( "VAT_AM", VAT_AM );
			selectList.get( j ).put( "SUP_AM", SUP_AM );
			Object GISU_DT = null;
			GISU_DT = selectList.get( j ).get( "GISU_DT" );
			if ( GISU_DT != null ) {
				if ( GISU_DT.toString( ).equals( "null" ) ) {
					GISU_DT = "";
				}
			}
			else {
				GISU_DT = "";
			}
			Object PJT_NM = null;
			PJT_NM = selectList.get( j ).get( "PJT_NM" );
			if ( PJT_NM != null ) {
				if ( PJT_NM.toString( ).equals( "null" ) ) {
					PJT_NM = "";
				}
			}
			else {
				PJT_NM = "";
			}
			selectList.get( j ).put( "GISU_DT", GISU_DT );
			selectList.get( j ).put( "PJT_NM", PJT_NM );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	/**
	 * 급여데이터 임시데이블 및 g20_abdocu_t 에 저장
	 * setPayData doban7 2016. 10. 24.
	 * 
	 * @param payDataVO
	 * @param paraMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPayData.do", method = RequestMethod.POST )
	public ModelAndView setPayData ( @ModelAttribute ( "payDataVO" ) PayDataVO payDataVO, @RequestParam HashMap<String, Object> paraMap ) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		payDataVO.setEmp_cd( getEMP_CD( ) );
		Map<String, Object> map = null;
		int result = 0;
		Abdocu_B abdocu_B = null;
		try {
			map = acG20ExService.setPayData( payDataVO );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
			result = (Integer) map.get( "result" );
		}
		catch ( Exception e ) {
			map = new HashMap<String, Object>( );
			e.printStackTrace( );
			LOG.error( e );
			result = -1;
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		return mv;
	}
	
	@Autowired
	CommonService commonService;
	
	/**
	 * 물품구매의뢰서
	 * purcReqGoodsForm parkjm 2018. 3. 15.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqGoodsForm.do", method = RequestMethod.GET )
	public ModelAndView purcReqGoodsForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject( "loginVO", loginVO );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		requestMap.put( "purcReqType", "1" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqFormPop" );
		return mv;
	}
	
	/**
	 * 물품구매(종합쇼핑몰)의뢰서
	 * purcReqShopForm parkjm 2018. 3. 15.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqShopForm.do", method = RequestMethod.GET )
	public ModelAndView purcReqShopForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject( "loginVO", loginVO );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		requestMap.put( "purcReqType", "2" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqFormPop" );
		return mv;
	}
	
	/**
	 * 공사구매의뢰서
	 * purcReqConstructForm parkjm 2018. 3. 15.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqConstructForm.do", method = RequestMethod.GET )
	public ModelAndView purcReqConstructForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject( "loginVO", loginVO );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		requestMap.put( "purcReqType", "3" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqFormPop" );
		return mv;
	}
	
	/**
	 * 용역구매의뢰서
	 * purcReqServiceForm parkjm 2018. 3. 15.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqServiceForm.do", method = RequestMethod.GET )
	public ModelAndView purcReqServiceForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject( "loginVO", loginVO );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		requestMap.put( "purcReqType", "4" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqFormPop" );
		return mv;
	}
	
	/**
	 * 물품구매의뢰서 헤더저장 (G20_Abdocu_H)
	 * setpurcReqH parkjm 2018. 3. 15.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcReqH.do", method = RequestMethod.POST )
	public ModelAndView setpurcReqH ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_H, @RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyy" );
		String year = dateFormat.format( new Date( ) );
		conVo = GetConnection( );
		Map<String, Object> map = null;
		
		if ( abdocu_H.getErp_co_cd( ) == null || abdocu_H.getErp_co_cd( ).equals( "" ) ) {
			abdocu_H.setErp_co_cd( getCO_CD( ) );
		}
		HashMap<String, String> paraMap = new HashMap<String, String>( );
		paraMap.put( "GISU_DT", abdocu_H.getErp_gisu_dt( ) );
		paraMap.put( "CO_CD", abdocu_H.getErp_co_cd( ) );
		HashMap<String, String> gisuInfo = getErpGisuInfo( conVo, paraMap );
		
		abdocu_H.setInsert_id( loginVO.getUniqId( ) );
		abdocu_H.setModify_id( loginVO.getUniqId( ) );
		abdocu_H.setCompSeq( loginVO.getCompSeq( ) );
		abdocu_H.setCompName( loginVO.getOrganNm( ) );
		abdocu_H.setDeptSeq( loginVO.getOrgnztId( ) );
		abdocu_H.setDeptName( loginVO.getOrgnztNm( ) );
		abdocu_H.setEmpSeq( loginVO.getUniqId( ) );
		abdocu_H.setEmpName( loginVO.getName( ) );
		abdocu_H.setErp_gisu_from_dt( gisuInfo.get( "FROM_DT" ) );
		abdocu_H.setErp_gisu_to_dt( gisuInfo.get( "TO_DT" ) );
		abdocu_H.setErp_gisu( String.valueOf( gisuInfo.get( "GI_SU" ) ) );
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("compName", loginVO.getOrganNm());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("deptCode", loginVO.getOrgnztId());
		paramMap.put("deptName", loginVO.getOrgnztNm());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		paramMap.put("empName", loginVO.getName());
		paramMap.put("position", loginVO.getPositionNm());
		paramMap.put("duty", loginVO.getClassNm());
		paramMap.put("mgt_nm", paramMap.get("mgt_nm_encoding"));
		paramMap.put("year", year);
		paramMap.put("erp_co_cd", getCO_CD());
		paramMap.put("erp_gisu_from_dt", gisuInfo.get( "FROM_DT" ));
		paramMap.put("erp_gisu_to_dt", gisuInfo.get( "TO_DT" ));
		paramMap.put("erp_gisu", gisuInfo.get( "GI_SU" ));
		
		String result = null;
		String purcReqId = null;
		String purcReqHId = null;
		String consDocSeq = null;
		try {
			if (paramMap.get("purcReqId") != null && "".equals(paramMap.get("purcReqId"))) {
				map = acG20ExService.insertPurcReq( abdocu_H , paramMap);
			}
			else {
				map = acG20ExService.updatePurcReq( abdocu_H , paramMap);
			}
			result = String.valueOf( map.get( "result" ));
			purcReqId = String.valueOf( map.get( "purcReqId" ));
			purcReqHId = String.valueOf( map.get( "purcReqHId" ));
			consDocSeq = String.valueOf( map.get( "consDocSeq" ));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "purcReqId", purcReqId );
		mv.addObject( "purcReqHId", purcReqHId );
		mv.addObject( "consDocSeq", consDocSeq );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 물품구매의뢰서 조회 (G20_Abdocu_H)
	 * getPurcReq parkjm 2018. 3. 15.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcReq.do", method = RequestMethod.POST )
	public ModelAndView getPurcReq (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		try {
			map = acG20ExService.getPurcReq(paramMap);
			mv.addObject("purcReqInfo", map.get("purcReqInfo"));
			mv.addObject("purcReqHList", map.get("purcReqHList"));
			mv.addObject("purcReqAttachFileList", map.get("purcReqAttachFileList"));
			mv.addObject("purcReqAttachFileList2", map.get("purcReqAttachFileList2"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 예산정보 저장 setPurcReqB
	 * setPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcReqB.do", method = RequestMethod.POST )
	public ModelAndView setPurcReqB ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B, @RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_B.setInsert_id( loginVO.getUniqId( ) );
		abdocu_B.setModify_id( loginVO.getUniqId( ) );
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		Map<String, Object> map = null;
		String result = null;
		String purcReqBId = null;
		try {
			if ( abdocu_B.getAbdocu_b_no( ).equals( "0" ) ) {
				map = acG20ExService.insertPurcReqB( abdocu_B, paramMap);
			}
			else {
				map = acG20ExService.updatePurcReqB( abdocu_B, paramMap);
			}
			result = (String) map.get( "result" );
			purcReqBId = (String) map.get( "purcReqBId" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		mv.addObject( "purcReqBId", purcReqBId );
		return mv;
	}
	
	/**
	 * 
	 * delPurcReqH parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delPurcReqH.do", method = RequestMethod.POST )
	public ModelAndView delPurcReqH ( @ModelAttribute ( "abdocu_H" ) Abdocu_H abdocu_H ) {
		ModelAndView mv = new ModelAndView( );
		//		Map<String, Object> map = null;
		Integer result = 0;
		try {
			result = acG20ExService.delPurcReqH( abdocu_H );
			// 	        result = (Integer) map.get("result");
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}
	
	/**
	 * 
	 * delPurcReq_H parkjm 2018. 4. 3.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delPurcReq_H.do", method = RequestMethod.POST )
	public ModelAndView delPurcReq_H ( @ModelAttribute ( "abdocu_H" ) Abdocu_H abdocu_H ) {
		ModelAndView mv = new ModelAndView( );
		//		Map<String, Object> map = null;
		Integer result = 0;
		try {
			result = acG20ExService.delPurcReq_H( abdocu_H );
			// 	        result = (Integer) map.get("result");
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}

	/**
	 * 
	 * delPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delPurcReqB.do", method = RequestMethod.POST )
	public ModelAndView delPurcReqB ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		try {
			map = acG20ExService.delPurcReqB( abdocu_B );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addAllObjects( map );
		return mv;
	}

	/**
	 * 
	 * delPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delPurcReqT.do", method = RequestMethod.POST )
	public ModelAndView delPurcReqT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T ) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		Integer result = null;
		try {
			map = acG20ExService.delPurcReqT( abdocu_T );
			result = (Integer) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}
	
	/**
	 * 결의서 예산 조회 getPurcReqB
	 * getPurcReqB parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcReqB.do", method = RequestMethod.POST )
	public ModelAndView getPurcReqB ( @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_H ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_B> selectList = null;
		try {
			selectList = acG20ExService.getPurcReqB( abdocu_H );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 결의서 채주정보 가져오기 setPurcReqT
	 * setPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_T, paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcReqT.do", method = RequestMethod.POST )
	public ModelAndView setPurcReqT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T, @RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_T.setInsert_id( loginVO.getUniqId( ) );
		abdocu_T.setModify_id( loginVO.getUniqId( ) );
		abdocu_T.setEmp_nm( loginVO.getName( ) );
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		paramMap.put("emp_nm", loginVO.getName());
		Map<String, Object> map = null;
		String result = null;
		Abdocu_B abdocu_B = null;
		try {
			if ( abdocu_T.getAbdocu_t_no( ).equals( "0" ) ) {
				map = acG20ExService.insertPurcReqT( abdocu_T, paramMap);
			}
			else {
				map = acG20ExService.updatePurcReqT( abdocu_T, paramMap);
			}
			result = (String) map.get( "result" );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 결의서 채주정보 가져오기 getPurcReqT
	 * getPurcReqT parkjm 2018. 3. 20.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcReqT.do", method = RequestMethod.POST )
	public ModelAndView getPurcReqT ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_T> selectList = null;
		try {
			selectList = acG20ExService.getPurcReqT( abdocu_B );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}
	
	/**
	 * setPurcReqAttach
	 * setPurcReqAttach parkjm 2018. 3. 22.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcReqAttach.do", method = RequestMethod.POST )
	public ModelAndView setPurcReqAttach (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		Map<String, Object> map = null;
		String result = null;
		try {
				map = acG20ExService.setPurcReqAttach(paramMap);
			result = (String) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 결의서 채주정보 가져오기 makePurcReqNo
	 * setPurcReqT parkjm 2018. 3. 22.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/makePurcReqNo.do", method = RequestMethod.POST )
	public ModelAndView makePurcReqNo (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		paramMap.put("deptCode", loginVO.getOrgnztId());
		paramMap.put("deptName", loginVO.getOrgnztNm());
		paramMap.put("position", loginVO.getPositionNm());
		paramMap.put("duty", loginVO.getClassNm());
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyy" );
		String year = dateFormat.format( new Date( ) );
		paramMap.put("year", year);
		Map<String, Object> map = null;
		try {
			map = acG20ExService.makePurcReqNo(paramMap);
			mv.addObject( "purcReqInfo", map.get("purcReqInfo") );
			mv.addObject( "purcReqHBList", map.get("purcReqHBList") );
			mv.addObject( "purcReqTList1", map.get("purcReqTList1") );
			mv.addObject( "purcReqTList2", map.get("purcReqTList2") );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping(value = "/Ac/G20/Ex/excelUploadSave.do", method = RequestMethod.POST)
	public ModelAndView excelUploadSave(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = null;
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		map.put("empSeq", loginVO.getUniqId());
		map.put("empIp", loginVO.getIp());
		try {
			resultMap = acG20ExService.excelUploadSave(map, multi);
		} catch (Exception e) {
			e.printStackTrace( );
			LOG.error( e );
			resultMap = new HashMap<String, Object>();
			resultMap.put("result", "Failed");
			resultMap.put("message", "엑셀 데이터 업로드에 실패했습니다.");
		}
		mv.addObject("result", resultMap);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 구매의뢰서 리스트
	 * purcReqList parkjm 2018. 3. 27.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqList.do", method = RequestMethod.GET )
	public ModelAndView purcReqList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("mng", "N");
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcReqList" );
		return mv;
	}
	
	/**
	 * 구매의뢰서 리스트
	 * purcReqListMng parkjm 2018. 3. 28.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqListMng.do", method = RequestMethod.GET )
	public ModelAndView purcReqListMng ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("mng", "Y");
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcReqList" );
		return mv;
	}
	
	/**
	 * 구매의뢰서 리스트
	 * purcReqListMng parkjm 2019. 9. 02.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqListTemp.do", method = RequestMethod.GET )
	public ModelAndView purcReqListTemp ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("mng", "temp");
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcReqList" );
		return mv;
	}
	
	/**
	 * 구매의뢰서 리스트 데이터
	 * purcReqList parkjm 2018. 3. 27.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcReqListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcReqListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcReqListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcReqListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 부서 리스트
	 * getDeptList parkjm 2018. 3. 28.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getDeptList.do", method = RequestMethod.POST )
	public ModelAndView getDeptList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		mv.addObject("allDept", allDept);
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매의뢰서 뷰
	 * purcReqView parkjm 2018. 3. 28.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqView.do", method = RequestMethod.GET )
	public ModelAndView purcReqView ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqViewPop" );
		return mv;
	}
	
	/**
	 * 
	 * updatePurcReqState parkjm 2018. 3. 28.
	 * 
	 * @param abdocu_H
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcReqState.do", method = RequestMethod.POST )
	public ModelAndView updatePurcReqState (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			acG20ExService.updatePurcReqState(map);
			mv.addObject( "result", map.get("result") );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			mv.addObject( "result", "Failed" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * excelTemplateDown parkjm 2018. 3. 29.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "/Ac/G20/Ex/excelTemplateDown.do", method = RequestMethod.GET)
	@ResponseBody
	public void fileDown(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response){
		LOG.info("fileDown");
		try {
			String purcReqType = map.get("purcReqType") != null ? String.valueOf(map.get("purcReqType")) : "";
			String purcTrType = map.get("purcTrType") != null ? String.valueOf(map.get("purcTrType")) : "";
			String fileName = "purcReqGoods.xlsx";
			String extension = "xlsx";
			SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMddHHmmss" );
			String today = dateFormat.format( new Date( ) );
			String realFileName = "물품구매채주유형";
			
			if("2".equals(purcReqType)) {
				fileName = "purcReqShop.xlsx";
				realFileName = "물품구매(조달청-종합쇼핑몰)채주유형";
			}else if("3".equals(purcReqType) && "001".equals(purcTrType)) {
				fileName = "purcReqConstruct.xlsx";
				realFileName = "공사구매채주유형";
			}else if("4".equals(purcReqType) && "001".equals(purcTrType)) {
				fileName = "purcReqService.xlsx";
				realFileName = "용역채주유형";
			}
			
			realFileName = realFileName + "_" + today + "." + extension;
			String path = request.getSession().getServletContext().getRealPath("/resources/exceltemplate/"+fileName);
			commonService.fileDownLoad(realFileName, path, request, response);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
		}
	}
	
	/**
	 * 구매계약보고 리스트
	 * purcReqListMng parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContList.do", method = RequestMethod.GET )
	public ModelAndView purcContList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContList" );
		return mv;
	}
	
	/**
	 * 구매계약보고
	 * purcContRepForm parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContRepForm.do", method = RequestMethod.GET )
	public ModelAndView purcContRepForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.addObject( "loginVO", loginVO );
		mv.setViewName( "/ac/g20/ex/Popup/purcContRepFormPop" );
		return mv;
	}
	
	/**
	 * 거래처 조회
	 * getErpTrade parkjm 2018. 4. 3.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/getErpTrade.do", method = RequestMethod.POST)
	public ModelAndView getErpTradeList(@RequestParam Map<String, String> paraMap) throws Exception{
	        
		conVo = GetConnection();
	    if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
            paraMap.put("CO_CD", getCO_CD());
        }
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
	 * 계약정보 생성
	 * makeContInfo parkjm 2018. 4. 3.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/makeContInfo.do", method = RequestMethod.POST)
	public ModelAndView makeContInfo(@RequestParam Map<String, String> paraMap) throws Exception{
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put("empSeq", loginVO.getUniqId());
		paraMap.put("empIp", loginVO.getIp());
		
		String result = "Failed";
		String purcContId = "";
		
		try {
			purcContId = acG20ExService.makeContInfo(paraMap);
			result = "Success";
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
			result = "Failed";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("result", result);
		mv.addObject("purcContId", purcContId);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	/**
	 * 계약정보 수정
	 * updatePurcCont parkjm 2018. 4. 3.
	 * 
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/updatePurcCont.do", method = RequestMethod.POST)
	public ModelAndView updatePurcCont(@RequestParam Map<String, String> paraMap) throws Exception{
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put("empSeq", loginVO.getUniqId());
		paraMap.put("empIp", loginVO.getIp());
		
		String result = "Failed";
		
		try {
			System.out.println(paraMap);
			acG20ExService.updatePurcCont(paraMap);
			result = "Success";
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e);
			result = "Failed";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	/**
	 * getPurcCont 조회 (G20_Abdocu_H)
	 * getPurcReq parkjm 2018. 4. 3.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcCont.do", method = RequestMethod.POST )
	public ModelAndView getPurcCont (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		try {
			map = acG20ExService.getPurcCont(paramMap);
			mv.addObject("purcContInfo", map.get("purcContInfo"));
			mv.addObject("purcReqInfo", map.get("purcReqInfo"));
			mv.addObject("purcReqHList", map.get("purcReqHList"));
			mv.addObject("purcReqAttachFileList", map.get("purcReqAttachFileList"));
			mv.addObject("purcReqAttachFileList2", map.get("purcReqAttachFileList2"));
			mv.addObject("purcReqAttachFileListCont", map.get("purcReqAttachFileListCont"));
			mv.addObject("purcReqAttachFileListCont2", map.get("purcReqAttachFileListCont2"));
			mv.addObject("purcContAddTr", map.get("purcContAddTr"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 결의서 예산 조회 getPurcContB
	 * getPurcReqB parkjm 2018. 4. 3.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcContB.do", method = RequestMethod.POST )
	public ModelAndView getPurcContB (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_B> selectList = null;
		try {
			selectList = acG20ExService.getPurcContB( map );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "selectList", selectList );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 결의서 채주정보 가져오기 getPurcContT
	 * getPurcContT parkjm 2018. 4. 4.
	 * 
	 * @param abdocu_B
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcContT.do", method = RequestMethod.POST )
	public ModelAndView getPurcContT ( @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B ) {
		ModelAndView mv = new ModelAndView( );
		List<Abdocu_T> selectList = null;
		try {
			selectList = acG20ExService.getPurcContT( abdocu_B );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "selectList", selectList );
		return mv;
	}
	
	/**
	 * 결의서 채주정보 가져오기 setPurcContT
	 * setPurcContT parkjm 2018. 4. 4.
	 * 
	 * @param abdocu_T, paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcContT.do", method = RequestMethod.POST )
	public ModelAndView setPurcContT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T, @RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_T.setInsert_id( loginVO.getUniqId( ) );
		abdocu_T.setModify_id( loginVO.getUniqId( ) );
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		Map<String, Object> map = null;
		String result = null;
		Abdocu_B abdocu_B = null;
		try {
			map = acG20ExService.updatePurcContT( abdocu_T, paramMap);
			result = (String) map.get( "result" );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
			mv.addObject("purcContInfo", map.get("purcContInfo"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * delPurcContT parkjm 2018. 4. 4.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/delPurcContT.do", method = RequestMethod.POST )
	public ModelAndView delPurcContT ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T ) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		Integer result = null;
		try {
			map = acG20ExService.delPurcContT( abdocu_T );
			result = (Integer) map.get( "result" );
			mv.addObject("purcContInfo", map.get("purcContInfo"));
			mv.addObject("abdocu_B", map.get("abdocu_B"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		mv.addObject( "result", result );
		return mv;
	}
	
	/**
	 * 
	 * getPurcReqLeftAm parkjm 2018. 4. 4.
	 * 
	 * @param abdocu_T
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcReqLeftAm.do", method = RequestMethod.POST )
	public ModelAndView getPurcReqLeftAm ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T ) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("purcReqLeftAm", acG20ExService.getPurcReqLeftAm( abdocu_T ));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * checkPurcContComplete parkjm 2018. 4. 5.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/checkPurcContComplete.do", method = RequestMethod.POST )
	public ModelAndView checkPurcContComplete (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("checkCnt", acG20ExService.checkPurcContComplete( map ));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * checkPurcContApproval parkjm 2018. 4. 5.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/checkPurcContApproval.do", method = RequestMethod.POST )
	public ModelAndView checkPurcContApproval (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("checkCnt", acG20ExService.checkPurcContApproval( map ));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * purcContRepApprovalComplete parkjm 2018. 4. 5.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContRepApprovalComplete.do", method = RequestMethod.POST )
	public ModelAndView purcContRepApprovalComplete (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.purcContRepApprovalComplete( map ));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약보고현황 리스트
	 * purcContStateList parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContStateList.do", method = RequestMethod.GET )
	public ModelAndView purcConStatetList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContStateList" );
		return mv;
	}
	
	/**
	 * 구매의뢰서 리스트 데이터
	 * purcContListData parkjm 2018. 3. 27.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcContListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcContListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcContListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcContListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 구매계약체결
	 * purcContConcForm parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContConcForm.do", method = RequestMethod.GET )
	public ModelAndView purcContConcForm ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.addObject( "loginVO", loginVO );
		mv.setViewName( "/ac/g20/ex/Popup/purcContConcFormPop" );
		return mv;
	}
	
	/**
	 * 구매계약보기
	 * purcContConcView parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContConcView.do", method = RequestMethod.GET )
	public ModelAndView purcContConcView ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.addObject( "loginVO", loginVO );
		mv.setViewName( "/ac/g20/ex/Popup/purcContConcViewPop" );
		return mv;
	}
	
	/**
	 * 계약단계 변경
	 * updateContDocSts parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updateContDocSts.do")
	public ModelAndView updateContDocSts ( @RequestParam Map<String, Object> map){
		ModelAndView mv = new ModelAndView( );
		try {
			String result = String.valueOf(acG20ExService.updateContDocSts(map));
			mv.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 계약체결
	 * purcContracted parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContracted.do")
	public ModelAndView purcContracted ( @RequestParam Map<String, Object> map){
		ModelAndView mv = new ModelAndView( );
		try {
			String result = String.valueOf(acG20ExService.purcContracted(map));
			mv.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * setPurcContAttach
	 * setPurcContAttach parkjm 2018. 3. 22.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/setPurcContAttach.do", method = RequestMethod.POST )
	public ModelAndView setPurcContAttach (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("empIp", loginVO.getIp());
		Map<String, Object> map = null;
		String result = null;
		try {
				map = acG20ExService.setPurcContAttach(paramMap);
			result = (String) map.get( "result" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약체결현황 리스트
	 * purcContConcStateList parkjm 2018. 4. 2.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContConcStateList.do", method = RequestMethod.GET )
	public ModelAndView purcContConcStateList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContConcStateList" );
		return mv;
	}
	
	/**
	 * 구매계약검수 리스트
	 * purcContInspList parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContInspList.do", method = RequestMethod.GET )
	public ModelAndView purcContInspList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContInspList" );
		return mv;
	}
	
	/**
	 * 구매계약검수 리스트
	 * purcContInspList parkjm 2019. 9. 10.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContInspList2.do", method = RequestMethod.GET )
	public ModelAndView purcContInspList2 ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContInspList2" );
		return mv;
	}
	
	/**
	 * 구매계약검수 리스트 데이터
	 * purcContInspListData parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcContInspListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcContInspListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcContInspListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcContInspListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 구매계약검수
	 * purcContInsp parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContInsp.do", method = RequestMethod.GET )
	public ModelAndView purcContInsp ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcContInspPop" );
		return mv;
	}
	
	/**
	 * 구매계약검수
	 * purcContInsp parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContInsp2.do", method = RequestMethod.GET )
	public ModelAndView purcContInsp2 ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcContInspPop2" );
		return mv;
	}
	
	/**
	 * 첨부파일 키 생성
	 * makeFileKey parkjm 2018. 4. 11.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/makeFileKey.do")
	public ModelAndView makeFileKey ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			result = acG20ExService.makeFileKey(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "fileKey", result );
		mv.addObject( "params", requestMap );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 검수데이터 생성
	 * makeContInspInfo parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/makeContInspInfo.do")
	public ModelAndView makeContInspInfo ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			requestMap.put("empSeq", loginVO.getUniqId());
			requestMap.put("empIp", loginVO.getIp());
			result = acG20ExService.makeContInspInfo(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 검수데이터 조회
	 * getContInsp parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getContInsp.do")
	public ModelAndView getContInsp ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		Map<String, Object> resultMap = null;
		try {
			resultMap = acG20ExService.getContInsp(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "contInsp", resultMap.get("contInsp") );
		mv.addObject( "contInspT1", resultMap.get("contInspT1") );
		mv.addObject( "contInspT2", resultMap.get("contInspT2") );
		mv.addObject( "contInspAttachFile", resultMap.get("contInspAttachFile") );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 검수데이터 업데이트
	 * updatePurcContInsp parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContInsp.do")
	public ModelAndView updatePurcContInsp ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcContInsp(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 검수채주정보 업데이트
	 * updatePurcContInspT parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContInspT.do")
	public ModelAndView updatePurcContInspT ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcContInspT(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매의뢰 컨텐츠 생성
	 * updatePurcReqContent parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcReqContent.do")
	public ModelAndView updatePurcReqContent ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcReqContent(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약 정보 조회
	 * getPurcContDocInfo parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcContDocInfo.do")
	public ModelAndView getPurcContDocInfo ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			Map<String, Object> resultMap = acG20ExService.getPurcContDocInfo(requestMap);
			mv.addAllObjects(resultMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약 정보 조회
	 * inspTopBoxInit parkjm 2018. 4. 16.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/inspTopBoxInit.do")
	public ModelAndView inspTopBoxInit ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			mv.addObject("resultInfo",acG20ExService.inspTopBoxInit(requestMap));
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약 컨텐츠 생성
	 * updatePurcContContent parkjm 2018. 4. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContContent.do")
	public ModelAndView updatePurcContContent ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcContContent(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 소액구매의뢰서
	 * purcReqFormSmall parkjm 2018. 3. 15.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqFormSmall.do", method = RequestMethod.GET )
	public ModelAndView purcReqForm2 ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject( "loginVO", loginVO );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcReqFormSmallPop" );
		return mv;
	}
	
	/**
	 * 소액구매 계약금액 업데이트
	 * updatePurcReqContAm parkjm 2018. 4. 18.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcReqContAm.do")
	public ModelAndView updatePurcReqContAm ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			mv.addObject("contAm", acG20ExService.updatePurcReqContAm(requestMap));
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매검수 컨텐츠 생성
	 * updatePurcContInspContent parkjm 2018. 4. 20.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContInspContent.do")
	public ModelAndView updatePurcContInspContent ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcContInspContent(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매검수 상태 체크
	 * checkInspComplete parkjm 2018. 4. 24.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/checkInspComplete.do")
	public ModelAndView checkInspComplete( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			Map<String, Object>	 resultMap = acG20ExService.checkInspComplete(requestMap);
			mv.addObject("contStep", resultMap.get("contStep"));
			mv.addObject("contInspList", resultMap.get("contInspList"));
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약변경 리스트
	 * purcContModList parkjm 2018. 4. 24.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContModList.do", method = RequestMethod.GET )
	public ModelAndView purcContModList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContModList" );
		return mv;
	}
	
	/**
	 * 구매계약변경 리스트 데이터
	 * purcContModListData parkjm 2018. 4. 24.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcContModListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcContModListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcContModListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcContModListDataTotal(map)); //토탈
		
		return resultMap;
	}

	/**
	 * 변경계약 상세 조회
	 * getContMod parkjm 2018. 4. 25.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getContMod.do")
	public ModelAndView getContMod( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			Map<String, Object>	 resultMap = acG20ExService.getContMod(requestMap);
			mv.addAllObjects(resultMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 체크
	 * makeContModInfo parkjm 2020. 10. 19.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContModReqCheck.do")
	public ModelAndView purcContModReqCheck( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			mv.addObject( "result", acG20ExService.purcContModReqCheck(requestMap) );
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 데이터 생성
	 * makeContModInfo parkjm 2018. 4. 25.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/makeContModInfo.do")
	public ModelAndView makeContModInfo( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			requestMap.put("empSeq", loginVO.getUniqId());
			requestMap.put("empIp", loginVO.getIp());
			result = acG20ExService.makeContModInfo(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약변경 
	 * purcContMod parkjm 2018. 4. 26.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContMod.do", method = RequestMethod.GET )
	public ModelAndView purcContMod ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcContModPop" );
		return mv;
	}
	
	/**
	 * 구매계약변경 요청
	 * purcContModReq parkjm 2020. 6. 25.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContModReq.do", method = RequestMethod.GET )
	public ModelAndView purcContModReq ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcContModReqPop" );
		return mv;
	}
	
	/**
	 * 변경계약 데이터 업데이트
	 * updatePurcContMod parkjm 2018. 4. 25.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContMod.do")
	public ModelAndView updatePurcContMod( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = "Success";
		try {
			acG20ExService.updatePurcContMod(requestMap);
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 채주 데이터 업데이트
	 * updatePurcContModT parkjm 2018. 5. 1.
	 * 
	 * @param abdocu_T
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContModT.do", method = RequestMethod.POST )
	public ModelAndView updatePurcContMod ( @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T, @RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		String result = null;
		Abdocu_B abdocu_B = null;
		try {
			map = acG20ExService.updatePurcContModT( abdocu_T, paramMap);
			result = (String) map.get( "result" );
			abdocu_B = (Abdocu_B) map.get( "abdocu_B" );
			mv.addObject("purcContInfo", map.get("purcContInfo"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.addObject( "result", result );
		mv.addObject( "abdocu_B", abdocu_B );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 품의예산 금액 조회
	 * getApplyAm parkjm 2018. 5. 2.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getApplyAm.do", method = RequestMethod.POST )
	public ModelAndView getApplyAm (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			mv.addObject("applyAmInfo", acG20ExService.getApplyAm(paramMap));
			result = "Success";
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			result = "Failed";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 저장
	 * completePurcContMod parkjm 2018. 5. 2.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/completePurcContMod.do", method = RequestMethod.POST )
	public ModelAndView completePurcContMod (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			mv.addObject("resultData", acG20ExService.completePurcContMod(paramMap));
			result = "Success";
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			result = "Failed";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 변경계약 저장
	 * requestPurcContMod parkjm 2020. 6. 25.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/requestPurcContMod.do", method = RequestMethod.POST )
	public ModelAndView requestPurcContMod (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			mv.addObject("resultData", acG20ExService.requestPurcContMod(paramMap));
			result = "Success";
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			result = "Failed";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 대금지급 리스트
	 * purcContPayList parkjm 2018. 5. 3.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPayList.do", method = RequestMethod.GET )
	public ModelAndView purcContPayList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcContPayList" );
		return mv;
	}
	
	/**
	 * 대금지급 리스트 데이터
	 * purcContPayListData parkjm 2018. 5. 3.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcContPayListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcContPayListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcContPayListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcContPayListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 대금지급 
	 * purcContPay parkjm 2018. 5. 4.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPay.do", method = RequestMethod.GET )
	public ModelAndView purcContPay ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcContPayPop" );
		return mv;
	}
	
	/**
	 * 양식키 조회
	 * getTemplateKey parkjm 2018. 5. 8.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getTemplateKey.do", method = RequestMethod.POST )
	public ModelAndView getTemplateKey (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			result = String.valueOf(acG20ExService.getTemplateKey(paramMap));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			result = "Failed";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약 프로젝트 팝업
	 * purcContPjtPop parkjm 2018. 5. 8.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPjtPop.do" )
	public ModelAndView purcContPjtPop ( @RequestParam HashMap<String, String> paramMap ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject("loginVO", loginVO);
		mv.addObject( "param", paramMap );
		mv.setViewName( "/ac/g20/ex/SubPopup/purcContPjtPop" );
		return mv;
	}
	
	/**
	 * 구매계약 프로젝트 팝업 데이터
	 * getPurcContPjtList parkjm 2018. 5. 8.
	 * 
	 * @param paramMap
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcContPjtList.do", method = RequestMethod.POST )
	public ModelAndView getPurcContPjtList (@RequestParam HashMap<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			 mv.addObject("selectList", acG20ExService.getPurcContPjtList(paramMap));
			 result = "Success";
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			result = "Failed";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * insertPurcContPay parkjm 2018. 5. 8.
	 * 
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertPurcContPay.do", method = RequestMethod.POST )
	public ModelAndView insertPurcContPay ( Abdocu_H abdocu_H ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Abdocu_H result = null;
		Map<String, Object> map = null;
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		abdocu_H.setInsert_id( loginVO.getUniqId( ) );
		try {
			conVo = GetConnection();
			map = acG20ExService.insertPurcContPay( abdocu_H, conVo);
			result = (Abdocu_H) map.get( "result" );
			mv.addObject("purcContPayId", map.get("purcContPayId"));
		}
		catch ( Exception e ) {
			StringWriter sw = new StringWriter( );
			e.printStackTrace( new PrintWriter( sw ) );
			String exceptionAsStrting = sw.toString( );
			LOG.error( "Call by _EAAppDocW.do  : " + exceptionAsStrting );
			throw new Exception( exceptionAsStrting );
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * updatePurcContPay parkjm 2018. 5. 11.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContPay.do")
	public ModelAndView updatePurcContPay (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			acG20ExService.updatePurcContPay(map);
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * getPurcContPay parkjm 2018. 5. 11.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getPurcContPay.do")
	public ModelAndView getPurcContPay (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.getPurcContPay(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * purcContPayComplete parkjm 2018. 5. 18.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPayComplete.do")
	public ModelAndView purcContPayComplete (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.purcContPayComplete(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * purcContPayCompleteRollBack parkjm 2019. 10. 23.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPayCompleteRollBack.do", method = RequestMethod.POST )
	public ModelAndView purcContPayCompleteRollBack ( @RequestParam Map<String, Object> map ) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.purcContPayCompleteRollBack(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * updatePurcContPayContent parkjm 2018. 6. 1.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContPayContent.do")
	public ModelAndView updatePurcContPayContent (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.updatePurcContPayContent(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * getContPay parkjm 2018. 6. 1.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/getContPay.do")
	public ModelAndView getContPay (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.getContPay(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매물품현황 리스트
	 * purcItemList parkjm 2018. 6. 4.
	 * 
	 * @param requestMap
	 * @param abdocu
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcItemList.do", method = RequestMethod.GET )
	public ModelAndView purcItemList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcItemList" );
		return mv;
	}
	
	/**
	 * 제안평가업체관리 리스트
	 * proposalEvaluationMng ygkim 2020. 11. 25
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/proposalEvaluationMng.do", method = RequestMethod.GET )
	public ModelAndView proposalEvaluationMng ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/ac/g20/ex/proposalEvaluationMng" );
		return mv;
	}
	@RequestMapping ("/Ac/G20/Ex/proposalEvalList")
	@ResponseBody
	public Map<String, Object> proposalEvalList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", acG20ExService.proposalEvaluationList());
		resultMap.put("totalCount", acG20ExService.proposalEvaluationListTotal());
		System.out.println();
		return resultMap;
	}
	

	/**
	 * 구매물품현황 리스트 데이터
	 * purcItemListData parkjm 2018. 6. 4.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcItemListData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcItemListData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcItemListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcItemListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 
	 * updateItemType parkjm 2018. 6. 5.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updateItemType.do")
	public ModelAndView updateItemType (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.updateItemType(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매물품현황 리스트 데이터
	 * getContPopupList parkjm 2018. 6. 5.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/getContPopupList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getContPopupList(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.getContPopupListData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.getContPopupListDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 
	 * getErpTradeList parkjm 2018. 6. 15.
	 * @param paraMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/getRefDoc.do", method = RequestMethod.POST)
	public ModelAndView getRefDoc(@RequestParam Map<String, String> paraMap){
		List<HashMap<String, String>> selectList = null;
		try {
			selectList = acG20ExService.getRefDoc(paraMap);
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
	 * 구매의뢰서 목록
	 * purcReqFormList parkjm 2018. 6. 18.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcReqFormList.do", method = RequestMethod.GET )
	public ModelAndView purcReqFormList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcReqFormList" );
		return mv;
	}
	
	@RequestMapping("/Ac/G20/Ex/contractList")
	public String contractList(Model model, HttpServletRequest servletRequest) throws Exception {
		model.addAttribute("empInfo", commonService.commonGetEmpInfo(servletRequest));
		return "/ac/g20/ex/contractList";
	}
	
	@RequestMapping("/Ac/G20/Ex/getMainGrid")
	@ResponseBody
	public Map<String, Object> getMainGrid(@RequestParam Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", acG20ExService.getMainGrid(map));
		resultMap.put("totalCount", acG20ExService.getMainGridTotal(map));
		return resultMap;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/updateContTrInfo.do")
	public ModelAndView updateContTrInfo (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.updateContTrInfo(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 대금지급 G20 2.0
	 * purcContPayIframe parkjm 2020. 4. 13.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcContPayIframe.do", method = RequestMethod.GET )
	public ModelAndView purcContPayIframe ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/iframe/purcContPayIframe" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/insertAddTr.do")
	public ModelAndView insertAddTr (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.insertAddTr(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/deleteAddTr.do")
	public ModelAndView deleteAddTr (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.deleteAddTr(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 구매계약입찰 리스트
	 * purcBiddingList parkjm 2020. 6. 29.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingList.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcBiddingList" );
		return mv;
	}
	
	/**
	 * 구매계약입찰 관리
	 * purcBiddingMng parkjm 2020. 6. 29.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingMng.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingMng ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcBiddingMng" );
		return mv;
	}
	
	/**
	 * 입찰
	 * purcBiddingBeforePop parkjm 2020. 7. 08.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingBeforePop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingBeforePop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingBeforePop" );
		return mv;
	}
	
	/**
	 * 입찰
	 * purcBiddingPop parkjm 2020. 7. 08.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingPop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingPop" );
		return mv;
	}
	
	/**
	 * 입찰
	 * purcBiddingReBiddingPop parkjm 2020. 7. 08.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingReBiddingPop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingReBiddingPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingReBiddingPop" );
		return mv;
	}
	
	/**
	 * 
	 * insertPurcReqBidding parkjm 2020. 7. 9.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertPurcReqBidding.do", method = RequestMethod.POST )
	public ModelAndView insertPurcReqBidding ( @RequestParam HashMap<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			map.put("write_emp_seq", loginVO.getUniqId());
			String purc_req_bidding_id = acG20ExService.insertPurcReqBidding(map);
			mv.addObject("purc_req_bidding_id", purc_req_bidding_id);
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * purcBiddingData parkjm 22020. 7. 9.
	 * 
	 * @param requestMap
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/Ac/G20/Ex/purcBiddingData.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> purcBiddingData(@RequestParam Map<String, Object> map) throws Exception{
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", acG20ExService.purcBiddingData(map)); //리스트
		resultMap.put("totalCount", acG20ExService.purcBiddingDataTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
	 * 
	 * updatePurcBiddingState parkjm 2020. 7. 9.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcBiddingState.do", method = RequestMethod.POST )
	public ModelAndView updatePurcBiddingState (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			acG20ExService.updatePurcBiddingState(map);
			mv.addObject( "result", map.get("result") );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			mv.addObject( "result", "Failed" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * checkPurcBiddingApproval parkjm 2020. 7. 9.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/checkPurcBiddingApproval.do", method = RequestMethod.POST )
	public ModelAndView checkPurcBiddingApproval (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject( "docCnt", acG20ExService.checkPurcBiddingApproval(map) );
			mv.addObject( "result", "Success" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			mv.addObject( "result", "Failed" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * selectPurcReqDept parkjm 2020. 7. 10.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqDept.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqDept (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject( "deptInfo", acG20ExService.selectPurcReqDept(map) );
			mv.addObject( "result", "Success" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			mv.addObject( "result", "Failed" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 제안평가
	 * purcBiddingEvaluationPop parkjm 2020. 7. 08.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingEvaluationPop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingEvaluationPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingEvaluationPop" );
		return mv;
	}
	
	/**
	 * 
	 * insertPurcReqBiddingEvalTr parkjm 2020. 7. 15.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertPurcReqBiddingEvalTr.do", method = RequestMethod.POST )
	@ResponseBody
	public ModelAndView insertPurcReqBiddingEvalTr ( @RequestBody HashMap<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			map.put("write_emp_seq", loginVO.getUniqId());
			acG20ExService.insertPurcReqBiddingEvalTr(map);
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * selectPurcReqDept parkjm 2020. 7. 10.
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBiddingEvalTr.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqBiddingEvalTr (@RequestParam Map<String, Object> map) {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject( "trade", acG20ExService.selectPurcReqBiddingEvalTr(map) );
			mv.addObject( "result", "Success" );
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
			mv.addObject( "result", "Failed" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingNegoList.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingNegoList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		mv.addObject("mng", "N");
		mv.addObject("loginVO", loginVO);
		mv.addObject("allDept", allDept);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/purcBiddingNegoList" );
		return mv;
	}
	
	/**
	 * 기술협상
	 * purcBiddingEvaluationPop parkjm 2020. 7. 20.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingNegoRegPop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingNegoRegPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingNegoRegPop" );
		return mv;
	}
	
	/**
	 * 기술협상
	 * getPurcReq parkjm 2020. 7. 20.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBiddingNego.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqBiddingNego (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> map = null;
		try {
			map = acG20ExService.selectPurcReqBiddingNego(paramMap);
			mv.addObject("attachFileList", map.get("attachFileList"));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 입찰
	 * selectPurcReqBidding parkjm 2020. 7. 20.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBidding.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqBidding (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("biddingInfo", acG20ExService.selectPurcReqBidding(paramMap));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 입찰
	 * selectPurcReqBiddingRefer parkjm 2020. 7. 20.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBiddingRefer.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqBiddingRefer (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("biddingReferInfo", acG20ExService.selectPurcReqBiddingRefer(paramMap));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 입찰
	 * purcBiddingConsultationPop parkjm 2020. 7. 29.
	 * 
	 * @param requestMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/purcBiddingConsultationPop.do", method = RequestMethod.GET )
	public ModelAndView purcBiddingConsultationPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		requestMap.put( "mode", "0" );
		mv.addObject( "loginVO", EgovUserDetailsHelper.getAuthenticatedUser() );
		mv.addObject( "params", requestMap );
		mv.setViewName( "/ac/g20/ex/Popup/purcBiddingConsultationPop" );
		return mv;
	}
	
	/**
	 * 입찰
	 * selectRefDoc parkjm 2020. 7. 20.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectRefDoc.do", method = RequestMethod.POST )
	public ModelAndView selectRefDoc (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("refDocList", acG20ExService.selectRefDoc(paramMap));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * updatePurcContModReturn parkjm 2020. 8. 12.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/updatePurcContModReturn.do", method = RequestMethod.POST )
	public ModelAndView updatePurcContModReturn ( @RequestParam HashMap<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			acG20ExService.updatePurcContModReturn(map);
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * insertResTrade parkjm 2020. 8. 20.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertResTrade.do", method = RequestMethod.POST )
	public ModelAndView insertResTrade ( @RequestParam HashMap<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			map.put("emp_nm", loginVO.getName());
			map.put("emp_seq", loginVO.getUniqId());
			mv.addObject("tradeSeq", acG20ExService.insertResTrade(map));
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 
	 * insertResTrade parkjm 2020. 8. 25.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/insertPurcContPay2.do", method = RequestMethod.POST )
	public ModelAndView insertPurcContPay2 ( @RequestParam HashMap<String, Object> map ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		try {
			map.put("emp_nm", loginVO.getName());
			map.put("emp_seq", loginVO.getUniqId());
			acG20ExService.insertPurcContPay2(map);
			mv.addObject("result", "Success");
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * 입찰
	 * selectPurcReqBiddingEval parkjm 2020. 7. 20.
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBiddingEval.do", method = RequestMethod.POST )
	public ModelAndView selectPurcReqBiddingEval (@RequestParam HashMap<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.selectPurcReqBiddingEval(paramMap));
		}
		catch ( Exception e ) {
			e.printStackTrace( );
			LOG.error( e );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/updateContTrEvalInfo.do")
	public ModelAndView updateContTrEvalInfo (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.updateContTrEvalInfo(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/selectFormInfo.do")
	public ModelAndView selectFormInfo (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.selectFormInfo(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/updateResHeadNote.do")
	public ModelAndView updateResHeadNote (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.updateResHeadNote(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( value = "/Ac/G20/Ex/selectPurcReqBiddingEvalTrSocialBiz.do")
	public ModelAndView selectPurcReqBiddingEvalTrSocialBiz (@RequestParam Map<String, Object> map) throws Exception {
		ModelAndView mv = new ModelAndView( );
		try {
			mv.addObject("result", acG20ExService.selectPurcReqBiddingEvalTrSocialBiz(map));
		}
		catch ( Exception e ) {
			mv.addObject("result", "Failed");
			e.printStackTrace();
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	
}
