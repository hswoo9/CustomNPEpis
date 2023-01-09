package com.duzon.custom.outprocess.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.outprocess.service.OutProcessService;

@Controller
public class OutProcessController {
	private static final Logger logger = LoggerFactory.getLogger(OutProcessController.class);
	
	@Resource(name = "OutProcessService")
	OutProcessService outProcessService;
	
	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				title		제목
	 * 				content		본문
	 */
	@RequestMapping(value = "/outProcess/outProcessTempInsert")
	public ModelAndView outProcessTempInsert(@RequestParam Map<String, Object> map, ModelAndView mv) {
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			outProcessService.outProcessTempInsert(map);
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				title		제목
	 * 				content		본문
	 */
	@RequestMapping(value = "/outProcess/outProcessDocInterlockInsert")
	public ModelAndView outProcessDocInterlockInsert(@RequestParam Map<String, Object> map, ModelAndView mv) {
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			outProcessService.outProcessDocInterlockInsert(map);
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * Method	:	GET
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				docId		전자결재 id
	 * 				docSts		전자결재 상태(임시보관:10, 상신결재:20, 반려:100, 종결:90, 삭제:999)
	 * 				userId		로그인 사용자 키
	 */
	@RequestMapping(value = "/outProcess/outProcessSel")
	public ModelAndView outProcessSel(@RequestParam Map<String, Object> map, ModelAndView mv) {
		System.out.println(map);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			Map<String, Object> resultMap = outProcessService.outProcessSel(map);
			mv.addObject("title", resultMap.get("title"));
			mv.addObject("content", resultMap.get("content"));
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 * 				docId		전자결재 id
	 * 				docSts		전자결재 상태(임시보관:10, 상신결재:20, 반려:100, 종결:90, 삭제:999)
	 * 				userId		로그인 사용자 키
	 */
	@RequestMapping(value = "/outProcess/outProcessApp")
	public ModelAndView outProcessApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			outProcessService.outProcessApp(bodyMap);
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * Method	:	POST
	 * params	:	processId	프로세스 id
	 * 				approKey	외부시스템 연동키
	 */
	@RequestMapping(value = "/outProcess/outProcessDocSts")
	public ModelAndView outProcessDocSts(ModelAndView mv, @RequestParam Map<String, Object> map) {
		String resultCode = "SUCCESS";
		try{
			
			mv.addObject("result", outProcessService.outProcessDocSts(map));
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
		}
		mv.addObject("resultCode", resultCode);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * Method	:	POST
	 * params	:	targetId		타켓 id
	 * 				targetTableName	테켓 테이블명
	 */
	@RequestMapping(value = "/outProcess/makeFileKey")
	public ModelAndView makeFileKey(ModelAndView mv, @RequestParam Map<String, Object> map) {
		String resultCode = "SUCCESS";
		try{
			mv.addObject("fileKey", outProcessService.makeFileKey(map));
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
		}
		mv.addObject("resultCode", resultCode);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping(value = "/outProcess/makeEncFileKey")
	public ModelAndView fileUploadApi(ModelAndView mv, @RequestParam Map<String, Object> paramMap) throws Exception {
		String resultCode = "SUCCESS";
		try {
			mv.addObject("fileKey", outProcessService.makeEncFileKey(paramMap));
		} catch (Exception e) {
			logger.error(e.getMessage());
			resultCode = "FAIL";
		}
		mv.addObject("resultCode", resultCode);
		mv.setViewName("jsonView");
		return mv;
	}
}