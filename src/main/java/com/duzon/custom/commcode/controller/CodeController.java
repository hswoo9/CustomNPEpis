package com.duzon.custom.commcode.controller;


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

import com.duzon.custom.commcode.service.CListService;
import com.duzon.custom.common.service.CommonService;
import com.google.gson.Gson;

/**

  * @FileName : CodeController.java

  * @Project : CustomNPTpf

  * @Date : 2018. 8. 21. 

  * @작성자 : 김찬혁

  * @변경이력 :

  * @프로그램 설명 : 공통코드 관리

  */
@Controller
public class CodeController {

private static final Logger logger = LoggerFactory.getLogger(CodeController.class);


private static final int String = 0;


private static final int List = 0;
	

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private CListService clistService;	

	/**
		 * @MethodName : commCodeView
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 공통코드 관리 화면
		 */
	@RequestMapping(value = "/commcode/commCodeView", method = RequestMethod.GET)
	public String commCodeView(Locale locale, Model model) {
		logger.info("Welcome commCodeView! The client locale is {}.", locale);
		List<Map<String, Object>> groupCd = commonService.getGroupCd(null);
		model.addAttribute("groupCd", new Gson().toJson(groupCd));
		return "/commcode/commCodeView";
	}
	/**
		 * @MethodName : codeList
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 공통코드 리스트
		 */
	@RequestMapping(value = "/commcode/codeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> codeList(@RequestParam Map<String, Object> map){
		logger.info("codeList");
		
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", clistService.codeList(map)); //리스트
		resultMap.put("totalCount", clistService.codeListTotal(map)); //토탈
		
		return resultMap;
	}
	
	/**
		 * @MethodName : addCommCode
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 공통코드 추가
		 */
	@RequestMapping(value="/commcode/addCommCode", method = RequestMethod.POST)
	@ResponseBody
	public String addCommCode(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("addCommCode");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		map.put("userId", loginMap.get("erpEmpSeq"));
		int flag = clistService.addCommCode(map);
		
		return flag+"";
	}
	

	/**
		 * @MethodName : commonMod
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 공통코드 수정
		 */
	@RequestMapping(value="/commcode/commonMod", method = RequestMethod.POST)
	@ResponseBody
	public String commonMod(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("commonMod");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		map.put("userId", loginMap.get("erpEmpSeq"));
		int flag = clistService.commonMod(map);
		
		return flag+"";
	}
	
	
	/**
		 * @MethodName : delCommCode
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 공통코드 삭제
		 */
	@RequestMapping(value = "/commcode/delCommCode", method = RequestMethod.POST)
	@ResponseBody
	public String delCommCode(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("delCommCode");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		clistService.delCommCode(loginMap, map);
		return "ok";
	}
	
	/**
		 * @MethodName : getGroupCode
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 그룹코드 가져오기
		 */
	@RequestMapping(value = "/commcode/getGroupCode", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> getGroupCode(@RequestParam Map<String, Object> map){
		logger.info("getGroupCode");			
		//리턴용 map
		
//		System.out.println(map);
		
		List<Map<String, Object>> resultMap = commonService.getGroupCd(map);
		
		return resultMap;
	}
	
	/**
		 * @MethodName : getCommCodeList
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 하위코드 가져오기
		 */
	@RequestMapping(value = "/commcode/getCommCodeList", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> getCommCodeList(@RequestParam Map<String, Object> map){
		logger.info("getCommCodeList");			
		//리턴용 map
		
//		System.out.println(map);
		
		List<Map<String, Object>> resultMap = clistService.getCommCodeList(map);
		
		return resultMap;
	}
	

	
}
