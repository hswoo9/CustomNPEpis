package com.duzon.custom.vacationApply.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;


import com.duzon.custom.commcode.service.CListService;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.vacationApply.service.vacationApplyService;
import com.google.gson.Gson;

import net.sf.json.JSONArray;

@Controller
public class vacationApplyController {

	private static final Logger logger = LoggerFactory.getLogger(vacationApplyController.class);
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private vacationApplyService vacationApplyService;
	
	@Autowired
	private CListService cListService;
	
	/**
	 * @MethodName : familyApply
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2020. 5. 25
	 * 설명 : 부양가족신청 화면
	 */
	@RequestMapping(value="/vacationApply/benefitMaster")
	public String benefitMaster(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("benefitMaster");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/benefitMaster";
	}
	
	/**
	 * @MethodName : familyApply
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2020. 5. 25
	 * 설명 : 부양가족신청 화면
	 */
	@RequestMapping(value="/vacationApply/familyApply", method = {RequestMethod.GET, RequestMethod.POST})
	public String familyApply(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("familyApply");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/familyApply";
	}
	
	@RequestMapping(value="/vacationApply/familyReport")
	public String familyReport(Locale locale, Model model, HttpServletRequest servletRequest, @RequestParam Map<String, Object> param) throws NoPermissionException {
		
		logger.info("familyReport");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
		model.addAttribute("family_apply_id", param.get("family_apply_id"));
		model.addAttribute("apply_from_date", param.get("apply_from_date"));
		model.addAttribute("apply_to_date", param.get("apply_to_date"));
		model.addAttribute("report_type", param.get("report_type"));
		model.addAttribute("access_type", param.get("access_type"));
		model.addAttribute("appro_status", param.get("appro_status"));
		model.addAttribute("apply_type", param.get("apply_type"));
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/familyReport";
	}
	
	/**
	 * @MethodName : familyApply
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2020. 5. 25
	 * 설명 : 부양가족신청 화면
	 */
	@RequestMapping(value="/vacationApply/familyApplyAdmin")
	public String familyApplyAdmin(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("familyApplyAdmin");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/familyApplyAdmin";
	}

	@RequestMapping(value="/vacationApply/familyBenefitManage")
	public String familyBenefitManage(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("familyBenefitManage");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/familyBenefitManage";
	}
	
	/**
	 * @MethodName : scholarship
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2019. 5. 15
	 * 설명 : 학자금신청 화면
	 */
	@RequestMapping(value="/vacationApply/scholarship")
	public String scholarship(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("scholarship");
		
		Map<String, Object> codeMap = new HashMap<String, Object>();
		codeMap.put("tableName", "dj_relationship");
		codeMap.put("orderName", "relationship_id");
		codeMap.put("skip", "0");
		codeMap.put("pageSize", "1000");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
		loginMap.put("family_relationship", "70");

		String [] status = {"0", "1","3"};
		
		codeMap.put("emp_seq", loginMap.get("empSeq"));
		codeMap.put("status", status);
		
		Map<String, Object> familyInfo = vacationApplyService.familyApplyDetailList(codeMap);
		
		model.addAttribute("userInfo", loginMap);
		model.addAttribute("familyInfo", new Gson().toJson(familyInfo));
		
		return "/vacationApply/scholarship";
	}
	
	@RequestMapping(value="/vacationApply/scholarshipAdmin")
	public String scholarshipAdmin(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("scholarshipAdmin");
		
		Map<String, Object> codeMap = new HashMap<String, Object>();
		codeMap.put("tableName", "dj_relationship");
		codeMap.put("orderName", "relationship_id");
		codeMap.put("skip", "0");
		codeMap.put("pageSize", "1000");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
		loginMap.put("family_relationship", "70");

		String [] status = {"0", "1","3"};
		
		codeMap.put("emp_seq", loginMap.get("empSeq"));
		codeMap.put("status", status);
		
		Map<String, Object> familyInfo = vacationApplyService.familyApplyDetailList(codeMap);
		
		model.addAttribute("userInfo", loginMap);
		model.addAttribute("familyInfo", new Gson().toJson(familyInfo));
		
		return "/vacationApply/scholarshipAdmin";
	}
	
	@RequestMapping(value="/vacationApply/scholarshipUser")
	public String scholarshipUser(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("scholarshipUser");
		
		Map<String, Object> codeMap = new HashMap<String, Object>();
		codeMap.put("tableName", "dj_relationship");
		codeMap.put("orderName", "relationship_id");
		codeMap.put("skip", "0");
		codeMap.put("pageSize", "1000");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
		Map<String, Object> familyInfo = vacationApplyService.familyApplyDetailList(codeMap);
		
		model.addAttribute("userInfo", loginMap);
		model.addAttribute("familyInfo", new Gson().toJson(familyInfo));
		
		return "/vacationApply/scholarshipUser";
	}
	
	@RequestMapping(value="/vacationApply/scholarshipReport")
	public String scholarshipReport(Locale locale, Model model, HttpServletRequest servletRequest, @RequestParam Map<String, Object> param) throws NoPermissionException {
		
		logger.info("scholarshipReport");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
		model.addAttribute("education_expense_id", param.get("education_expense_id"));
		model.addAttribute("apply_from_date", param.get("apply_from_date"));
		model.addAttribute("apply_to_date", param.get("apply_to_date"));
		model.addAttribute("report_type", param.get("report_type"));
		model.addAttribute("access_type", param.get("access_type"));
		model.addAttribute("appro_status", param.get("appro_status"));
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/scholarshipReport";
	}
	
	@RequestMapping(value="/vacationApply/scholarshipManage")
	public String scholarshipManage(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("scholarshipManage");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/scholarshipManage";
	}
	
	/**
	 * @MethodName : welfareApply
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2020. 6. 14
	 * 설명 : 복지포인트신청 화면
	 */
	@RequestMapping(value="/vacationApply/welfareApply")
	public String welfareApply(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("welfareApply");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/welfareApply";
	}
	
	/**
	 * @MethodName : welfareApplyAdmin
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2020. 5. 25
	 * 설명 : 복지포인트승인 화면
	 */
	@RequestMapping(value="/vacationApply/welfareApplyAdmin")
	public String welfareApplyAdmin(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("welfareApplyAdmin");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/welfareApplyAdmin";
	}
	
	@RequestMapping(value="/vacationApply/welfareBenefitManage")
	public String welfareBenefitManage(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("welfareBenefitManage");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));
		
		Map<String, Object> viewInfo = (vacationApplyService.viewUserInfo(loginMap.get("empSeq"))).get(0);
		loginMap.put("emp_seq", loginMap.get("empSeq"));
//		List<Map<String, Object>> familyInfo = certificateDAO.familyList(loginMap);
		model.addAttribute("userInfo", loginMap);
//		model.addAttribute("familyInfo",  new Gson().toJson(familyInfo));
		model.addAttribute("viewInfo",  new Gson().toJson(viewInfo));
		return "/vacationApply/welfareBenefitManage";
	}
	
	/**
	 * @MethodName : CodeRegister
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2019. 5. 15
	 * 설명 : 코드등록 화면
	 */
	@RequestMapping(value="/vacationApply/CodeRegister")
	public String CodeRegister(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("CodeRegister");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("group_code", "FAMILY_TYPE"); //가족
		model.addAttribute("family_code", new Gson().toJson(cListService.getCommCodeList(map)));

		model.addAttribute("userInfo", loginMap);

		return "/vacationApply/CodeRegister";
	}
	

	
	//기본jsp매핑 끝
	
	/**
	 * @MethodName : codeList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록 리스트
	 */
	@RequestMapping(value="/vacationApply/codeList")
	@ResponseBody
	public Map<String, Object> codeList(@RequestParam Map<String, Object> map){
		
		logger.info("codeList");

		return vacationApplyService.codeList(map);
	}
	
	/**
	 * @MethodName : codeDuplChk
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드중복체크
	 */
	@RequestMapping(value="/vacationApply/codeDuplChk")
	@ResponseBody
	public boolean codeDuplChk(@RequestParam Map<String, Object> map){
		
		logger.info("codeDuplChk");

		return vacationApplyService.codeDuplChk(map);
	}
	
	/**
	 * @MethodName : codeAdd
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록
	 */
	@RequestMapping(value="/vacationApply/codeAdd")
	@ResponseBody
	public boolean codeAdd(@RequestParam Map<String, Object> map){
		
		logger.info("codeAdd");

		vacationApplyService.codeAdd(map);
		
		return true;
	}
	
	/**
	 * @MethodName : codeDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드삭제
	 */
	@RequestMapping(value="/vacationApply/codeDelete")
	@ResponseBody
	public boolean codeDelete(@RequestParam Map<String, Object> map){
		
		logger.info("codeDelete");

		vacationApplyService.codeDelete(map);
		
		return true;
	}

	/**
	 * @MethodName : ccDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조사유형별 리스트 조회
	 */
	@RequestMapping(value="/vacationApply/ccDetailList")
	@ResponseBody
	public Map<String, Object> ccDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("ccDetailList");

		return vacationApplyService.ccDetailList(map);
	}
	
	/**
	 * @MethodName : spDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금유형별 리스트 조회
	 */
	@RequestMapping(value="/vacationApply/spDetailList")
	@ResponseBody
	public Map<String, Object> spDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("spDetailList");

		return vacationApplyService.spDetailList(map);
	}
	
	/**
	 * @MethodName : ccDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세등록
	 */
	@RequestMapping(value="/vacationApply/ccDetailRegister")
	@ResponseBody
	public boolean ccDetailRegister(@RequestParam Map<String, Object> map){
		
		logger.info("ccDetailRegister");

		vacationApplyService.ccDetailRegister(map);
		
		return true;
	}
	
	/**
	 * @MethodName : ccDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세수정
	 */
	@RequestMapping(value="/vacationApply/ccDetailModify")
	@ResponseBody
	public boolean ccDetailModify(@RequestParam Map<String, Object> map){
		
		logger.info("ccDetailModify");

		vacationApplyService.ccDetailModify(map);
		
		return true;
	}
	
	/**
	 * @MethodName : ccDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세삭제
	 */
	@RequestMapping(value="/vacationApply/ccDetailDelete")
	@ResponseBody
	public boolean ccDetailDelete(@RequestParam Map<String, Object> map){
		
		logger.info("ccDetailDelete");

		vacationApplyService.ccDetailDelete(map);
		
		return true;
	}
	
	/**
	 * @MethodName : spDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세등록
	 */
	@RequestMapping(value="/vacationApply/spDetailRegister")
	@ResponseBody
	public boolean spDetailRegister(@RequestParam Map<String, Object> map){
		
		logger.info("spDetailRegister");

		vacationApplyService.spDetailRegister(map);
		
		return true;
	}
	
	/**
	 * @MethodName : spDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세수정
	 */
	@RequestMapping(value="/vacationApply/spDetailModify")
	@ResponseBody
	public boolean spDetailModify(@RequestParam Map<String, Object> map){
		
		logger.info("spDetailModify");

		vacationApplyService.spDetailModify(map);
		
		return true;
	}
	
	/**
	 * @MethodName : spDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세삭제
	 */
	@RequestMapping(value="/vacationApply/spDetailDelete")
	@ResponseBody
	public boolean spDetailDelete(@RequestParam Map<String, Object> map){
		
		logger.info("spDetailDelete");

		vacationApplyService.spDetailDelete(map);
		
		return true;
	}
	
	//코드등록 끝
	//경조 시작
	
	/**
	 * @MethodName : ccApplyList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조신청 리스트
	 */
	@RequestMapping(value="/vacationApply/ccApplyList")
	@ResponseBody
	public Map<String, Object> ccApplyList(@RequestParam Map<String, Object> map){
		
		logger.info("ccApplyList");

		return vacationApplyService.ccApplyList(map);
	}
	
	
	/**
	 * @MethodName : ccApplySave
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조금신청 저장
	 */
	@RequestMapping(value="/vacationApply/ccApplySave")
	@ResponseBody
	public Map<String, Object> ccApplySave(@RequestParam Map<String, Object> map){
		
		logger.info("ccApplySave");

		return vacationApplyService.ccApplySave(map);
	}

	/**
	 * @MethodName : ccApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조사신청삭제
	 */
	@RequestMapping(value="/vacationApply/ccApplyDeleteRow")
	@ResponseBody
	public boolean ccApplyDeleteRow(@RequestParam Map<String, Object> map){
		
		logger.info("ccApplyDeleteRow");

		vacationApplyService.ccApplyDeleteRow(map);
		
		return true;
	}
	
	//경조사 끝
	//학자금 시작
	
	/**
	 * @MethodName : scholarApplyList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청 리스트
	 */
	@RequestMapping(value="/vacationApply/scholarApplyList")
	@ResponseBody
	public Map<String, Object> scholarApplyList(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApplyList");

		return vacationApplyService.scholarApplyList(map);
	}
	

	/**
	 * @MethodName : scholarApplyDetailList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청상세 리스트
	 */
	@RequestMapping(value="/vacationApply/scholarApplyDetailList")
	@ResponseBody
	public Map<String, Object> scholarApplyDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApplyDetailList");

		return vacationApplyService.scholarApplyDetailList(map);
	}
	
	/**
	 * @MethodName : scholarDetailList
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 등록학자금 리스트 조회
	 */
	@RequestMapping(value="/vacationApply/scholarDetailList")
	@ResponseBody
	public Map<String, Object> scholarDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("scholarDetailList");

		return vacationApplyService.scholarDetailList(map);
	}
	
	/**
	 * @MethodName : scholarApplySave
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 학자금신청
	 */
	@RequestMapping(value="/vacationApply/scholarApplySave")
	@ResponseBody
	public Map<String, Object> scholarApplySave(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApplySave");

		return vacationApplyService.scholarApplySave(map);
	}
	
	/**
	 * @MethodName : scholarApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 6. 1
	 * 설명 : 경조사신청삭제
	 */
	@RequestMapping(value="/vacationApply/scholarApplyDeleteRow")
	@ResponseBody
	public boolean scholarApplyDeleteRow(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApplyDeleteRow");

		vacationApplyService.scholarApplyDeleteRow(map);
		
		return true;
	}
	
	@RequestMapping(value="/vacationApply/scholarApprovalUpdate")
	@ResponseBody
	public Map<String, Object> scholarApprovalUpdate(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApprovalUpdate");
		
		return vacationApplyService.scholarApprovalUpdate(map);
	}
	
	@RequestMapping(value="/vacationApply/scholarApprovalCancle")
	@ResponseBody
	public Map<String, Object> scholarApprovalCancle(@RequestParam Map<String, Object> map){
		
		logger.info("scholarApprovalCancle");
		
		return vacationApplyService.scholarApprovalCancle(map);
	}

	@RequestMapping(value="/vacationApply/scholarApplyFileSave")
	@ResponseBody
	public Map<String, Object> scholarApplyFileSave(@RequestParam Map<String, Object> map,Locale locale, Model model, MultipartHttpServletRequest multi) throws Exception{
		
		logger.info("scholarApplyFileSave");

		return vacationApplyService.scholarApplyFileSave(map,multi,model);
	}
	
	/**
	 * @MethodName : famliyApplyList
	 * @author : doxx
	 * @since : 2020. 5. 25
	 * 설명 : 부양가족신청 리스트
	 */
	@RequestMapping(value="/vacationApply/famliyApplyList")
	@ResponseBody
	public Map<String, Object> famliyApplyList(@RequestParam Map<String, Object> map){
		
		logger.info("famliyApplyList");

		return vacationApplyService.famliyApplyList(map);
	}
	
	@RequestMapping(value="/vacationApply/famliyApplySave")
	@ResponseBody
	public Map<String, Object> famliyApplySave(@RequestParam Map<String, Object> map){
		
		logger.info("famliyApplySave");

		return vacationApplyService.famliyApplySave(map);
	}
	
	@RequestMapping(value="/vacationApply/famliyApplyFileSave")
	@ResponseBody
	public Map<String, Object> famliyApplyFileSave(@RequestParam Map<String, Object> map,Locale locale, Model model, MultipartHttpServletRequest multi) throws Exception{
		
		logger.info("famliyApplyFileSave");

		return vacationApplyService.famliyApplyFileSave(map,multi,model);
	}
	
	@RequestMapping(value="/vacationApply/familyApplyDetailList")
	@ResponseBody
	public Map<String, Object> familyApplyDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("familyApplyDetailList");

		return vacationApplyService.familyApplyDetailList(map);
	}
	
	@RequestMapping(value="/vacationApply/familyApplyDeleteRow")
	@ResponseBody
	public boolean familyApplyDeleteRow(@RequestParam Map<String, Object> map){
		
		logger.info("familyApplyDeleteRow");

		vacationApplyService.familyApplyDeleteRow(map);
		
		return true;
	}
	
	@RequestMapping(value="/vacationApply/familyApprovalUpdate")
	@ResponseBody
	public Map<String, Object> familyApprovalUpdate(@RequestParam Map<String, Object> map){
		
		logger.info("familyApprovalUpdate");

		return vacationApplyService.familyApprovalUpdate(map);
	}
	
	
	@RequestMapping(value="/vacationApply/benefitSave")
	@ResponseBody
	public Map<String, Object> benefitSave(@RequestParam Map<String, Object> map){
		
		logger.info("benefitSave");

		return vacationApplyService.benefitSave(map);
	}
	
	@RequestMapping(value="/vacationApply/benefitList")
	@ResponseBody
	public Map<String, Object> benefitList(@RequestParam Map<String, Object> map){
		
		logger.info("benefitList");

		return vacationApplyService.benefitList(map);
	}
	
	@RequestMapping(value="/vacationApply/benefitDetailList")
	@ResponseBody
	public Map<String, Object> benefitDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("benefitDetailList");

		return vacationApplyService.benefitDetailList(map);
	}
	
	@RequestMapping(value="/vacationApply/getBenefitTypeList")
	@ResponseBody
	public Map<String, Object> getBenefitTypeList(@RequestParam Map<String, Object> map){
		
		logger.info("getBenefitTypeList");

		return vacationApplyService.getBenefitTypeList(map);
	}
	
	@RequestMapping(value="/vacationApply/getScholarshipManageList")
	@ResponseBody
	public Map<String, Object> getScholarshipManageList(@RequestParam Map<String, Object> map){
		
		logger.info("getScholarshipManageList");

		return vacationApplyService.getScholarshipManageList(map);
	}
	
	@RequestMapping(value="/vacationApply/welfareApplyList")
	@ResponseBody
	public Map<String, Object> welfareApplyList(@RequestParam Map<String, Object> map){
		
		logger.info("welfareApplyList");

		return vacationApplyService.welfareApplyList(map);
	}
	
	@RequestMapping(value="/vacationApply/welfareApplySave")
	@ResponseBody
	public Map<String, Object> welfareApplySave(@RequestParam Map<String, Object> map){
		
		logger.info("welfareApplySave");

		return vacationApplyService.welfareApplySave(map);
	}
	
	@RequestMapping(value="/vacationApply/welfareApplyFileSave")
	@ResponseBody
	public Map<String, Object> welfareApplyFileSave(@RequestParam Map<String, Object> map,Locale locale, Model model, MultipartHttpServletRequest multi) throws Exception{
		
		logger.info("welfareApplyFileSave");

		return vacationApplyService.welfareApplyFileSave(map,multi,model);
	}
	
	@RequestMapping(value="/vacationApply/welfareApplyDetailList")
	@ResponseBody
	public Map<String, Object> welfareApplyDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("welfareApplyDetailList");

		return vacationApplyService.welfareApplyDetailList(map);
	}
	
	@RequestMapping(value="/vacationApply/welfareApplyDeleteRow")
	@ResponseBody
	public boolean welfareApplyDeleteRow(@RequestParam Map<String, Object> map){
		
		logger.info("welfareApplyDeleteRow");

		vacationApplyService.welfareApplyDeleteRow(map);
		
		return true;
	}
	
	@RequestMapping(value="/vacationApply/welfareApprovalUpdate")
	@ResponseBody
	public Map<String, Object> welfareApprovalUpdate(@RequestParam Map<String, Object> map){
		
		logger.info("welfareApprovalUpdate");

		return vacationApplyService.welfareApprovalUpdate(map);
	}
	
}
