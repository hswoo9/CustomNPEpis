package com.duzon.custom.common.controller;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.CtFileUtile;
import com.google.gson.Gson;


@Controller
@RequestMapping(value="/common")
public class CommonController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	
	
	/**
	 * YH
	 * 2017. 12. 11.
	 * 설명 : 공통 파일 다운로드
	 */
	@RequestMapping(value = "/ctFileDownLoad", method = RequestMethod.GET)
	@ResponseBody
	public void ctFileDownLoad(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		
		logger.info("ctFileDownLoad");
		
		String path = (String) map.get("filePath");
		String fileNm = (String) map.get("fileNm");
		
		CtFileUtile ctFileUtile = new CtFileUtile();
		
		ctFileUtile.fileDownLoad(path, fileNm, request, response);
	
	}
	
	/**
	 * Method Name : fileDownLoad
	 * Parameter : fileName, fileFullPath [Encoded]
	 * 작성일 : 2020. 10. 15.
	 * 작성자 : jy
	 * Method 설명 : 파일 다운로드
	 */
	@RequestMapping(value = "/fileDownLoad")
	@ResponseBody 
	public void fileDownLoad(@RequestParam Map<String, Object> map,
			HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@RequestParam String fileName, @RequestParam String fileFullPath) throws NoPermissionException, IOException {
		System.out.println("@@@@@");
		logger.info("== excelDownLoad ==");
		
		map.put("fileName", URLDecoder.decode(fileName, "UTF-8"));
		map.put("fileFullPath", URLDecoder.decode(fileFullPath, "UTF-8"));
		
		try {
			commonService.fileDown2(map, servletRequest, servletResponse);
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	}
	
	@RequestMapping(value = "/ctFileUpLoad", method = RequestMethod.POST)
	@ResponseBody
	public void ctFileUpLoad(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("ctFileUpLoad");
		
		commonService.ctFileUpLoad(map, multi);
		

	}
	
	/**
		 * @MethodName : empInformation
		 * @author : gato
		 * @since : 2018. 1. 23.
		 * 설명 : 사원팝업
		 */
	@RequestMapping(value = "/empInformation", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> empInformation(@RequestParam Map<String, Object> map){
		logger.info("empInformation");
//		System.out.println("코드 컨트롤러");
		
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", commonService.empInformation(map)); //리스트
		if(map.containsKey("pageSize")){
			resultMap.put("totalCount", commonService.empInformationTotal(map)); //토탈
		}
		
		
		return resultMap;
	}
	
	@RequestMapping(value = "/selectEmp", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectEmp(@RequestParam Map<String, Object> map){
		logger.info("selectEmp");
//		System.out.println("코드 컨트롤러");
		
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", commonService.selectEmp(map)); //리스트
		
		
		return resultMap;
	}
	
	@RequestMapping(value = "/getDutyPosition", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDutyPosition(@RequestParam String subKey) {
		logger.info("getDutyPosition");
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 
		 
		 resultMap.put("getDutyPosition", commonService.getDutyPosition(subKey));
		
		return resultMap;
	}
	
	@RequestMapping(value = "/getDeptList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDeptList(@RequestParam String subKey) {
		logger.info("getDeptList");
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 
		 
		 resultMap.put("getDeptList", commonService.getDeptList(subKey));
		
		return resultMap;
	}
	
	@RequestMapping(value = "/getEmpInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getEmpInfo(@RequestParam String empSeq) {
		logger.info("getEmpInfo");
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 
		 
		 resultMap.put("getEmpInfo", commonService.getEmpInfo(empSeq));
		
		return resultMap;
	}
	/**
	 * @MethodName : fileList
	 * @author : gato
	 * @since : 2018. 1. 8.
	 * 설명 : 첨부파일 목록 가져오기
	 */
	@RequestMapping(value = "/fileList")
	@ResponseBody
	public Map<String, Object> fileList(@RequestParam Map<String, Object> map){
		logger.info("systemFileList");		
		map.put("tableName", map.get("fileName"));
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", commonService.fileList(map));
		
		
		return resultMap;
	}
	
	/**
	 * @MethodName : fileDown
	 * @author : gato
	 * @since : 2018. 1. 9.
	 * 설명 : 정보시스템 파일 다운로드
	 */
	@RequestMapping(value = "/fileDown", method = RequestMethod.GET)
	@ResponseBody
	public void fileDown(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response){
		logger.info("fileDown");
		
		commonService.fileDown(map, request, response);
		
	}
	
	@RequestMapping(value = "/fileDelete", method = RequestMethod.POST)
	@ResponseBody
	public void fileDelete(@RequestParam Map<String, Object> map) {
		logger.info("fileDelete");
		commonService.fileDelete(map);
		
	}
	
	@RequestMapping(value = "/fileInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> fileInfo(@RequestParam Map<String, Object> map) {
		logger.info("fileInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("map", commonService.fileInfo(map));
		return resultMap;
	}
	
	@RequestMapping(value = "/getUserList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUserList(@RequestParam Map<String, Object> map) {
		logger.info("getUserList");
		
		return commonService.getUserList(map);
		
	}
	
	@RequestMapping(value = "/getDeptList2", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDeptList2(@RequestParam Map<String, Object> map) {
		logger.info("getDeptList");
		
		return commonService.getDeptList2(map);
		
	}

	
	@RequestMapping(value = "/getProjectList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getProjectList(@RequestParam Map<String, Object> map) {
		logger.info("getProjectList");
		
		return commonService.getProjectList(map);
		
	}
	
	@RequestMapping(value = "/getBudgetList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBudgetList(@RequestParam Map<String, Object> map) {
		logger.info("getBudgetList");
		
		return commonService.getBudgetList(map);
		
	}
	
	@RequestMapping(value = "/getBudgetList2", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBudgetList2(@RequestParam Map<String, Object> map) {
		logger.info("getBudgetList2");
		
		return commonService.getBudgetList2(map);
		
	}

	@RequestMapping(value = "/getPosition", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPosition(@RequestParam Map<String, Object> map) {
		logger.info("getPosition");
		
		return commonService.getPosition(map);
		
	}
	
	@RequestMapping ( value = "/deptPopup", method = RequestMethod.GET )
	public String deptPopup (Model model, HttpServletRequest servletRequest) throws NoPermissionException {

		Map<String, Object> login = commonService.commonGetEmpInfo(servletRequest);
		model.addAttribute("data", commonService.ctDept((String) login.get("deptSeq")));
		model.addAttribute("userInfo", login);
		
		return "/commcode/deptPopup";
	}
	
	@RequestMapping ( value = "/userPopup", method = RequestMethod.GET )
	public String userPopup (@RequestParam Map<String, Object> map, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		Map<String, Object> login = commonService.commonGetEmpInfo(servletRequest);
		model.addAttribute("data", commonService.ctDept((String) login.get("deptSeq")));
		model.addAttribute("userInfo", login);
		model.addAttribute("code", map.get("code"));
		model.addAttribute("no", map.get("no"));
		
		return "/commcode/userPopup";
	}
	
	/**
	 * DOXX
	 * 2020. 07. 13.
	 * 설명 : 조직도 팝업
	 */
	@RequestMapping ( value = "/organizationChartPopUp", method = {RequestMethod.GET, RequestMethod.POST} )
	public String organizationChartPopUp(@RequestParam Map<String, Object> map, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		Map<String, Object> login = commonService.commonGetEmpInfo(servletRequest);
		model.addAttribute("data", commonService.ctDept((String) login.get("deptSeq")));
		model.addAttribute("userInfo", login);
		model.addAttribute("code", map.get("code"));
		model.addAttribute("memberList",  new Gson().toJson(commonService.empInformation(map)));
		
		return "/commcode/organizationChartPopUp";
	}
	
	@RequestMapping ( value = "/getOrganChartDatas", method = RequestMethod.POST )
	@ResponseBody
	public Map<String, Object> getOrganChartDatas(@RequestParam Map<String, Object> map, Model model, HttpServletRequest servletRequest, HttpServletResponse response) throws NoPermissionException, ServletException, IOException {
		
		Map<String, Object> datas = new HashMap<String, Object>();
		Map<String, Object> login = commonService.commonGetEmpInfo(servletRequest);
		datas.put("data", commonService.ctDept((String) login.get("deptSeq")));
		datas.put("userInfo", login);
		datas.put("code", map.get("code"));
		datas.put("memberList",  new Gson().toJson(commonService.empInformation(map)));
		return datas;
	}
	

}
