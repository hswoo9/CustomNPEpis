package com.duzon.custom.bsrp.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.bsrp.service.BsrpService;
import com.duzon.custom.commcode.service.CListService;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.ExcelUtil;

import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class BsrpController {

	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(BsrpController.class);

	@Autowired
	private CListService cListService;
	
	@Autowired
	private BsrpService bsrpService;
	
	@Autowired
	private CommonService commonService;
	

	/**
	 * 2019. 8. 19.
	 * yh
	 * :출장신청 리스트
	 */
	@RequestMapping(value = "/bsrp/bsrpReqstList", method = RequestMethod.GET)
	public String bsrpReqstList(Model model, @RequestParam Map<String, Object> map) {
		logger.info("bsrpReqstList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/bsrp/bsrpReqstList";

	}
	
	/**
	 * 2019. 8. 19.
	 * yh
	 * :관내여비 사용자 리스트
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctList", method = RequestMethod.GET)
	public String whthrcTrvctList(Model model, HttpServletRequest servletRequest) throws NoPermissionException  {
		logger.info("whthrcTrvctList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
//		Map<String, Object> loginVO = commonService.commonGetEmpInfo(servletRequest);
//		Map<String, Object> empName = commonService.getEmpName((String) loginVO.get("erpEmpSeq")) ;
//		loginVO.putAll(empName);
		model.addAttribute("userInfo", loginVO);

		
		return "/bsrp/whthrcTrvctList";
		
	}

	/**
	 * 2019. 8. 21.
	 * yh
	 * :출장 관리자
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminList", method = RequestMethod.GET)
	public String bsrpAdminList(Model model) {
		logger.info("bsrpAdminList");
		
		/*출장 공통코드 정의
		1. 교통수단
		그룹코드 : BSRP_TFCMN
		코드 : 001..
		
		2. 지역
		그룹코드 : BSRP_AREA
		코드 : 001..
		
		3. 요금종류
		그룹코드 : BSRP_TRFF
		코드 : 001..*/
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("group_code", "BSRP_TFCMN"); //교통수단
		model.addAttribute("bsrp_tfcmn", cListService.getCommCodeList(map));

		map.put("group_code", "BSRP_AREA");//지역
		model.addAttribute("bsrp_area", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_TRFF");//오금종류
		model.addAttribute("bsrp_trff", cListService.getCommCodeList(map));
		
		return "/bsrp/bsrpAdminList";
		
	}
	
	/**
	 * 2019. 8. 21.
	 * yh
	 * :출장 관리자 조회
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpAdminListSerch(@RequestParam Map<String, Object> map){
		logger.info("bsrpAdminListSerch");
		
		return bsrpService.bsrpAdminListSerch(map);
	}

	/**
	 * 2019. 8. 21.
	 * yh
	 * :출장 관리자 등록
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminSave", method = RequestMethod.POST)
	@ResponseBody
	public void bsrpAdminSave(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		logger.info("bsrpAdminSave");
	
		try {
			map.putAll( commonService.commonGetEmpInfo(servletRequest) );
		} catch (NoPermissionException e) {
			e.printStackTrace();
		}
		
		bsrpService.bsrpAdminSave(map);
	}

	/**
	 * 2019. 8. 21.
	 * yh
	 * :출장관리 관리자 삭제
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminDel", method = RequestMethod.POST)
	@ResponseBody
	public void bsrpAdminDel(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		logger.info("bsrpAdminDel");
		
		try {
			map.putAll( commonService.commonGetEmpInfo(servletRequest) );
		} catch (NoPermissionException e) {
			e.printStackTrace();
		}
		
		bsrpService.bsrpAdminDel(map);
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :출장신청
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/bsrp/bsrpReqstView", method = RequestMethod.GET) 
	public String bsrpReqstView(Model model) throws Exception {
		logger.info("bsrpReqstView");	
		
		
		/*출장 공통코드 정의
		1. 교통수단
		그룹코드 : BSRP_TFCMN
		코드 : 001..
		
		2. 지역
		그룹코드 : BSRP_AREA
		코드 : 001..
		
		3. 요금종류
		그룹코드 : BSRP_TRFF
		코드 : 001..*/
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("group_code", "BSRP_TFCMN"); //교통수단
		model.addAttribute("bsrp_tfcmn", cListService.getCommCodeList(map));
		
		map.put("group_code", "BIZTRIP_AIRLINE"); //항공사
		model.addAttribute("biztrip_airline", cListService.getCommCodeList(map));

		map.put("group_code", "BSRP_AREA");//지역
		model.addAttribute("bsrp_area", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_TRFF");//오금종류
		model.addAttribute("bsrp_trff", cListService.getCommCodeList(map));
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put( "CO_CD", loginVO.getErpCoCd() );
		map.put( "EMP_CD", loginVO.getErpEmpCd() );
		map.put( "LANGKIND", loginVO.getLangCode() );
		
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMdd" );
		map.put("GISU_DT", dateFormat.format( new Date() ));
		
		Abdocu_H resultAbdocu = null;
		
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		
		Map<String, Object> erpUserInfo = commonService.getErpUserInfo( map );
		
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		resultAbdocu.setErp_gisu( String.valueOf(erpuser.get("GI_SU")) );
		resultAbdocu.setErp_gisu_to_dt( erpuser.get("TO_DT") );
		resultAbdocu.setErp_gisu_from_dt( erpuser.get("FROM_DT") );
		
		
		model.addAttribute("abdocu", resultAbdocu);

		model.addAttribute("userInfo", loginVO);
		
		return "/bsrp/bsrpReqstView";
		
	}

	/**
	 * 2019. 8. 28.
	 * yh
	 * :출장신청
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/bsrp/bsrpReqstOSView", method = RequestMethod.GET) 
	public String bsrpReqstOSView(Model model) throws Exception {
		logger.info("bsrpReqstOSView");	
		
		
		/*출장 공통코드 정의
		1. 교통수단
		그룹코드 : BSRP_TFCMN
		코드 : 001..
		
		2. 지역
		그룹코드 : BSRP_AREA
		코드 : 001..
		
		3. 요금종류
		그룹코드 : BSRP_TRFF
		코드 : 001..*/
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("group_code", "BSRP_TFCMN"); //교통수단
		model.addAttribute("bsrp_tfcmn", cListService.getCommCodeList(map));
		
		map.put("group_code", "BIZTRIP_AIRLINE"); //항공사
		model.addAttribute("biztrip_airline", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_AREA");//지역
		model.addAttribute("bsrp_area", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_TRFF");//오금종류
		model.addAttribute("bsrp_trff", cListService.getCommCodeList(map));
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put( "CO_CD", loginVO.getErpCoCd() );
		map.put( "EMP_CD", loginVO.getErpEmpCd() );
		map.put( "LANGKIND", loginVO.getLangCode() );
		
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMdd" );
		map.put("GISU_DT", dateFormat.format( new Date() ));
		
		Abdocu_H resultAbdocu = null;
		
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		
		Map<String, Object> erpUserInfo = commonService.getErpUserInfo( map );
		
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		resultAbdocu.setErp_gisu( String.valueOf(erpuser.get("GI_SU")) );
		resultAbdocu.setErp_gisu_to_dt( erpuser.get("TO_DT") );
		resultAbdocu.setErp_gisu_from_dt( erpuser.get("FROM_DT") );
		
		
		model.addAttribute("abdocu", resultAbdocu);
		
		model.addAttribute("userInfo", loginVO);
		
		return "/bsrp/bsrpReqstOSView";
		
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :erp정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/bsrp/erpInfoData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> erpInfoData(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		logger.info("erpInfoData");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put( "LANGKIND", loginVO.getLangCode( ) );
		
		Abdocu_H resultAbdocu = null;
		
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		
		Map<String, Object> erpUserInfo = commonService.getErpUserInfo( map );
		
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		resultAbdocu.setErp_gisu( String.valueOf(erpuser.get("GI_SU")) );
		resultAbdocu.setErp_gisu_to_dt( erpuser.get("TO_DT") );
		resultAbdocu.setErp_gisu_from_dt( erpuser.get("FROM_DT") );
		
		
		Map<String, Object> erpToEmpInfo = bsrpService.getErpToEmpInfo(map);
		
		
		map.put( "abdocu", resultAbdocu );
		map.put( "erpToEmpInfo", erpToEmpInfo );
		
		return map;
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :
	 */
	@RequestMapping(value = "/bsrp/getFareListSearch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getFareListSearch(@RequestParam Map<String, Object> map){
		logger.info("getFareListSearch");
		
		return bsrpService.getFareListSearch(map);
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :출장여비(관내) 승인자
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctAppList", method = RequestMethod.GET)
	public String whthrcTrvctAppList(Model model) {
		logger.info("whthrcTrvctAppList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		return "/bsrp/whthrcTrvctAppList";
		
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :출장여비(관내) 관리자
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctAdminList", method = RequestMethod.GET)
	public String whthrcTrvctAdminList(Model model) {
		logger.info("whthrcTrvctAdminList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		return "/bsrp/whthrcTrvctAdminList";
		
	}
	
	/**
	 * 2019. 8. 28.
	 * yh
	 * :출장여비(관내) 리스트
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctPjtList", method = RequestMethod.GET)
	public String whthrcTrvctPjtList(Model model) {
		logger.info("whthrcTrvctPjtList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		return "/bsrp/whthrcTrvctPjtList";
		
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :관내 출장 등록
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctSave", method = RequestMethod.POST)
	@ResponseBody
	public void whthrcTrvctSave(@RequestParam Map<String, Object> map){
		logger.info("whthrcTrvctSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.whthrcTrvctSave(map);
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object>  whthrcTrvctListSerch(@RequestParam Map<String, Object> map){
		logger.info("whthrcTrvctListSerch");
		
		return bsrpService.whthrcTrvctListSerch(map);
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :직급별 출장 여비 관리자 리스트 
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminPositionList", method = RequestMethod.GET)
	public String bsrpAdminPositionList(Model model) {
		logger.info("bsrpAdminPositionList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
//		model.addAttribute("positionList", commonService.getPositionList());
		
		return "/bsrp/bsrpAdminPositionList";
		
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :직급별 출장 여비 등록
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminPositionSave", method = RequestMethod.POST)
	@ResponseBody
	public void  bsrpAdminPositionSave(@RequestParam Map<String, Object> map){
		logger.info("bsrpAdminPositionSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpAdminPositionSave(map);
	}

	/**
	 * 2019. 9. 2.
	 * yh
	 * :출장 관리자 직급 조회
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminPositionListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpAdminPositionListSerch(@RequestParam Map<String, Object> map){
		logger.info("bsrpAdminPositionListSerch");
		
		return bsrpService.bsrpAdminPositionListSerch(map);
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :직급별 출장 여비 삭제
	 */
	@RequestMapping(value = "/bsrp/bsrpAdminPositionDel", method = RequestMethod.POST)
	@ResponseBody
	public void bsrpAdminPositionDel(@RequestParam Map<String, Object> map){
		logger.info("bsrpAdminPositionDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpAdminPositionDel(map);
	}

	/**
	 * 2019. 8. 29.
	 * yh
	 * :출장 승인
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctApp", method = RequestMethod.POST)
	@ResponseBody
	public void whthrcTrvctApp(@RequestParam Map<String, Object> map){
		logger.info("whthrcTrvctApp");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.whthrcTrvctApp(map);
	}

	/**
	 * 2019. 8. 29.
	 * yh
	 * :출장 승인 취소
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctAppCancel", method = RequestMethod.POST)
	@ResponseBody
	public void whthrcTrvctAppCancel(@RequestParam Map<String, Object> map){
		logger.info("whthrcTrvctAppCancel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.whthrcTrvctAppCancel(map);
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :출장 신청 취소
	 */
	@RequestMapping(value = "/bsrp/whthrcTrvctCancel", method = RequestMethod.POST)
	@ResponseBody
	public void whthrcTrvctCancel(@RequestParam Map<String, Object> map){
		logger.info("whthrcTrvctCancel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.whthrcTrvctCancel(map);
	}

	
	/**
	 * 2019. 9. 10.
	 * yh
	 * :유저 직급조회
	 */
	@RequestMapping(value = "/bsrp/getUserPosition", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUserPosition(@RequestParam Map<String, Object> map){
		logger.info("getUserPosition");
		
		return bsrpService.getUserPosition(map);
	}
	
	/**
	 * 2019. 9. 10.
	 * yh
	 * :출장신청 등록
	 */
	@RequestMapping(value = "/bsrp/bsrpSave", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpSave(@RequestParam Map<String, Object> map, @ModelAttribute ( "abdocu" ) Abdocu_H abdocu_H, @ModelAttribute ( "abdocu_B" ) Abdocu_B abdocu_B, @ModelAttribute ( "abdocu_T" ) Abdocu_T abdocu_T){
		logger.info("bsrpSave");
		//신청
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		abdocu_H.setInsert_id( loginVO.getUniqId( ) );
		abdocu_H.setModify_id( loginVO.getUniqId( ) );
		abdocu_B.setInsert_id( loginVO.getUniqId( ) );
		abdocu_B.setModify_id( loginVO.getUniqId( ) );
		abdocu_T.setInsert_id( loginVO.getUniqId( ) );
		abdocu_T.setModify_id( loginVO.getUniqId( ) );
		
		map.put("userSeq", loginVO.getUniqId());
		map.put("abdocu_H", abdocu_H);
		map.put("abdocu_B", abdocu_B);
		map.put("abdocu_T", abdocu_T);
		
		bsrpService.bsrpSave(map);
		
		return map;
	}
	
	/**
	 * 2019. 9. 10.
	 * yh
	 * :양식 그리기
	 */
	@RequestMapping(value = "/bsrp/bsrpHtml", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView bsrpHtml(@RequestParam Map<String, Object> map){
		logger.info("bsrpHtml");
		//신청 양식 그리기
		
		ModelAndView mav = new ModelAndView();
		
		if(map.get("templteType").equals("a")){
			mav.setViewName("/bsrp/html/bsrp1");
		}
		
		mav.addObject("data", map);
		
		return mav;
	}

	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				docId		전자결재 id
	 * 				docSts		전자결재 상태(임시보관:10, 상신결재:20, 반려:100, 종결:90, 삭제:999)
	 * 				userId		로그인 사용자 ID
	 * 				empSeq		로그인 사용자 키
	 */
	@RequestMapping(value = "/bsrp/bsrpApp")
	public ModelAndView bsrpApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		logger.info("bsrpApp");
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			bsrpService.bsrpApp(bodyMap);
		}catch(Exception e){
			logger.info(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :
	 */
	@RequestMapping(value = "/bsrp/bsrpReqstListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object>  bsrpReqstListSerch(@RequestParam Map<String, Object> map){
		logger.info("bsrpReqstListSerch");
		
		return bsrpService.bsrpReqstListSerch(map);
	}
	
	/**
	 * 2019. 9. 19.
	 * jm
	 * :출장결과보고
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/bsrp/bsrpReportView", method = RequestMethod.GET) 
	public String bsrpReportView(Model model, @RequestParam Map<String, Object> requestMap) throws Exception {
		logger.info("bsrpReportView");	
		
		
		/*출장 공통코드 정의
		1. 교통수단
		그룹코드 : BSRP_TFCMN
		코드 : 001..
		
		2. 지역
		그룹코드 : BSRP_AREA
		코드 : 001..
		
		3. 요금종류
		그룹코드 : BSRP_TRFF
		코드 : 001..*/
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("group_code", "BSRP_TFCMN"); //교통수단
		model.addAttribute("bsrp_tfcmn", cListService.getCommCodeList(map));
		
		map.put("group_code", "BIZTRIP_AIRLINE"); //항공사
		model.addAttribute("biztrip_airline", cListService.getCommCodeList(map));

		map.put("group_code", "BSRP_AREA");//지역
		model.addAttribute("bsrp_area", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_TRFF");//오금종류
		model.addAttribute("bsrp_trff", cListService.getCommCodeList(map));
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put( "CO_CD", loginVO.getErpCoCd() );
		map.put( "EMP_CD", loginVO.getErpEmpCd() );
		map.put( "LANGKIND", loginVO.getLangCode() );
		
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMdd" );
		map.put("GISU_DT", dateFormat.format( new Date() ));
		
		Abdocu_H resultAbdocu = null;
		
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		
		Map<String, Object> erpUserInfo = commonService.getErpUserInfo( map );
		
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		resultAbdocu.setErp_gisu( String.valueOf(erpuser.get("GI_SU")) );
		resultAbdocu.setErp_gisu_to_dt( erpuser.get("TO_DT") );
		resultAbdocu.setErp_gisu_from_dt( erpuser.get("FROM_DT") );
		
		
		model.addAttribute("abdocu", resultAbdocu);

		model.addAttribute("userInfo", loginVO);
		
		model.addAttribute("bs_seq", requestMap.get("bs_seq"));
		
		return "/bsrp/bsrpReportView";
		
	}
	
	/**
	 * 2019. 11. 22.
	 * jm
	 * :출장결과보고
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/bsrp/bsrpReportView2", method = RequestMethod.GET) 
	public String bsrpReportView2(Model model, @RequestParam Map<String, Object> requestMap) throws Exception {
		logger.info("bsrpReportView2");	
		
		
		/*출장 공통코드 정의
		1. 교통수단
		그룹코드 : BSRP_TFCMN
		코드 : 001..
		
		2. 지역
		그룹코드 : BSRP_AREA
		코드 : 001..
		
		3. 요금종류
		그룹코드 : BSRP_TRFF
		코드 : 001..*/
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("group_code", "BSRP_TFCMN"); //교통수단
		model.addAttribute("bsrp_tfcmn", cListService.getCommCodeList(map));
		
		map.put("group_code", "BIZTRIP_AIRLINE"); //항공사
		model.addAttribute("biztrip_airline", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_AREA");//지역
		model.addAttribute("bsrp_area", cListService.getCommCodeList(map));
		
		map.put("group_code", "BSRP_TRFF");//오금종류
		model.addAttribute("bsrp_trff", cListService.getCommCodeList(map));
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put( "CO_CD", loginVO.getErpCoCd() );
		map.put( "EMP_CD", loginVO.getErpEmpCd() );
		map.put( "LANGKIND", loginVO.getLangCode() );
		
		SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMdd" );
		map.put("GISU_DT", dateFormat.format( new Date() ));
		
		Abdocu_H resultAbdocu = null;
		
		HashMap<String, String> erpuser = new HashMap<String, String>( );
		
		Map<String, Object> erpUserInfo = commonService.getErpUserInfo( map );
		
		if ( erpUserInfo.containsKey( "erpuser" ) ) {
			erpuser = (HashMap<String, String>) erpUserInfo.get( "erpuser" );
		}
		
		resultAbdocu = new Abdocu_H( );
		resultAbdocu.setErp_co_cd( erpuser.get( "CO_CD" ) );
		resultAbdocu.setErp_co_nm( erpuser.get( "CO_NM" ) );
		resultAbdocu.setErp_div_cd( erpuser.get( "DIV_CD" ) );
		resultAbdocu.setErp_div_nm( erpuser.get( "DIV_NM" ) );
		resultAbdocu.setErp_dept_cd( erpuser.get( "DEPT_CD" ) );
		resultAbdocu.setErp_dept_nm( erpuser.get( "DEPT_NM" ) );
		resultAbdocu.setErp_emp_cd( erpuser.get( "EMP_CD" ) );
		resultAbdocu.setErp_emp_nm( erpuser.get( "KOR_NM" ) );
		resultAbdocu.setErp_gisu( String.valueOf(erpuser.get("GI_SU")) );
		resultAbdocu.setErp_gisu_to_dt( erpuser.get("TO_DT") );
		resultAbdocu.setErp_gisu_from_dt( erpuser.get("FROM_DT") );
		
		
		model.addAttribute("abdocu", resultAbdocu);
		
		model.addAttribute("userInfo", loginVO);
		
		model.addAttribute("bs_seq", requestMap.get("bs_seq"));
		
		return "/bsrp/bsrpReportView2";
		
	}
	
	/**
	 * 2019. 8. 29.
	 * yh
	 * :
	 */
	@RequestMapping(value = "/bsrp/getBsrpInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object>  getBsrpInfo(@RequestParam Map<String, Object> map){
		logger.info("getBsrpInfo");
		
		return bsrpService.getBsrpInfo(map);
	}
	
	/**
	 * 2019. 9. 10.
	 * yh
	 * :출장신청 등록
	 */
	@RequestMapping(value = "/bsrp/bsrpReportSave", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpReportSave(@RequestParam Map<String, Object> map){
		logger.info("bsrpReportSave");
		//신청
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpReportSave(map);
		
		return map;
	}
	
	/**
	 * 2019. 11. 22.
	 * yh
	 * :출장신청 등록
	 */
	@RequestMapping(value = "/bsrp/bsrpMileageUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpMileageUpdate(@RequestParam Map<String, Object> map){
		logger.info("bsrpMileageUpdate");
		//신청
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpMileageUpdate(map);
		
		return map;
	}
	
	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				docId		전자결재 id
	 * 				docSts		전자결재 상태(임시보관:10, 상신결재:20, 반려:100, 종결:90, 삭제:999)
	 * 				userId		로그인 사용자 ID
	 * 				empSeq		로그인 사용자 키
	 */
	@RequestMapping(value = "/bsrp/bsrpRApp")
	public ModelAndView bsrpRApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		logger.info("bsrpRApp");
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			bsrpService.bsrpRApp(bodyMap);
		}catch(Exception e){
			logger.info(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 2019. 10. 16.
	 * jm
	 * :출장내역서
	 */
	@RequestMapping(value = "/bsrp/bsrpStatementList", method = RequestMethod.GET)
	public String bsrpStatementList(Model model, @RequestParam Map<String, Object> map) {
		logger.info("bsrpStatementList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/bsrp/bsrpStatementList";

	}

	/**
	 * 2019. 10. 16.
	 * jm
	 * :출장내역서
	 */
	@RequestMapping(value = "/bsrp/bsrpStatementListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object>  bsrpStatementListSerch(@RequestParam Map<String, Object> map){
		logger.info("bsrpStatementListSerch");
		
		return bsrpService.bsrpStatementListSerch(map);
	}
	
	/**
	 * 2019. 10. 21.
	 * jm
	 * :출장내역서
	 */
	@RequestMapping(value = "/bsrp/bsrpStatementListExcel")
	@ResponseBody
	public void bsrpStatementListExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> map){
		logger.info("bsrpStatementListExcel");
		try {
			map.put("topSearchPlace", URLDecoder.decode(String.valueOf(map.get("topSearchPlace")),"UTF-8"));
			map.put("topSearchBudget2", URLDecoder.decode(String.valueOf(map.get("topSearchBudget2")),"UTF-8"));
			Map<String, Object> beans = bsrpService.bsrpStatementListSerch(map);
			
			String filename = String.valueOf(map.get("filename"));
			String templateFile = String.valueOf(map.get("templateFile"));
			
			ExcelUtil.download(request, response, beans, filename, templateFile);
		} catch (UnsupportedEncodingException e) {
			logger.info(e.getMessage());
		}
	}
	
	/**
	 * 2019. 10. 21.
	 * jm
	 * :지급일 저장
	 */
	@RequestMapping(value = "/bsrp/paymentDtSave", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> paymentDtSave(@RequestParam Map<String, Object> map){
		logger.info("paymentDtSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.paymentDtSave(map);
		
		return map;
	}
	
	/**
	 * 2019. 10. 30.
	 * jm
	 * :출장결과보고반송리스트
	 */
	@RequestMapping(value = "/bsrp/bsrpReturnList", method = RequestMethod.GET)
	public String bsrpReturnList(Model model, @RequestParam Map<String, Object> map) {
		logger.info("bsrpReturnList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/bsrp/bsrpReturnList";

	}
	
	/**
	 * 2019. 10. 30.
	 * jm
	 * :출장결과보고반송
	 */
	@RequestMapping(value = "/bsrp/bsrpReturn", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpReturn(@RequestParam Map<String, Object> map){
		logger.info("bsrpReturn");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpReturn(map);
		
		return map;
	}
	
	/**
	 * 2019. 10. 30.
	 * jm
	 * :출장결과보고반송취소
	 */
	@RequestMapping(value = "/bsrp/bsrpReturnCancel", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bsrpReturnCancel(@RequestParam Map<String, Object> map){
		logger.info("bsrpReturnCancel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("userSeq", loginVO.getUniqId());
		
		bsrpService.bsrpReturnCancel(map);
		
		return map;
	}
	
	/**
	 * 2019. 11. 01.
	 * jm
	 * :출장 환원
	 */
	@RequestMapping(value = "/bsrp/bsrpReturnConferList", method = RequestMethod.GET)
	public String bsrpReturnConferList(Model model, @RequestParam Map<String, Object> map) {
		logger.info("bsrpReturnConferList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/bsrp/bsrpReturnConferList";

	}
	
	/**
	 * 2019. 11. 10.
	 * jm
	 * :출장 누적마일리지
	 */
	@RequestMapping(value = "/bsrp/getBsrpMileage", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBsrpMileage(@RequestParam Map<String, Object> map){
		logger.info("getBsrpMileage");
		Map<String, Object> resultMap = bsrpService.getBsrpMileage(map);
		return resultMap;
	}
	
	/**
	 * 2019. 11. 18.
	 * jm
	 * :마일리지 리스트
	 */
	@RequestMapping(value = "/bsrp/bsrpMileageList", method = RequestMethod.GET)
	public String bsrpMileageList(Model model, @RequestParam Map<String, Object> map) {
		logger.info("bsrpMileageList");	
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/bsrp/bsrpMileageList";

	}
	
	/**
	 * 2019. 11. 18.
	 * jm
	 * :출장내역서
	 */
	@RequestMapping(value = "/bsrp/bsrpMileageListSerch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object>  bsrpMileageListSerch(@RequestParam Map<String, Object> map){
		logger.info("bsrpMileageListSerch");
		
		return bsrpService.bsrpMileageListSerch(map);
	}
}
