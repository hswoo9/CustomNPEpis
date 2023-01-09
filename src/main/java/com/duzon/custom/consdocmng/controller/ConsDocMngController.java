package com.duzon.custom.consdocmng.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.consdocmng.service.ConsDocMngService;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class ConsDocMngController {
	private static final Logger logger = LoggerFactory.getLogger(ConsDocMngController.class);
	
	@Autowired
	private ConsDocMngService consDocMngService;
	
	@RequestMapping ( "/consDocMng/consDocMng" )
	public ModelAndView consDocMng ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		logger.info( "consDocMng" );
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("params", params);
		mv.setViewName( "/consDocMng/consDocMng" );
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/selectConsDocMngList" )
	public ModelAndView selectConsDocMngList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		logger.info( "selectConsDocMngList" );
		ModelAndView mv = new ModelAndView( );
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			params.put("deptSeq", loginVO.getOrgnztId());
			mv.setViewName("jsonView");
			mv.addObject("list", consDocMngService.selectConsDocMngList(params));
			mv.addObject("totalCount", consDocMngService.selectConsDocMngListTotalCount(params));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/selectConsDocMngDList" )
	public ModelAndView selectConsDocMngDList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		logger.info( "selectConsDocMngDList" );
		ModelAndView mv = new ModelAndView( );
		try {
			mv.setViewName("jsonView");
			mv.addObject("list", consDocMngService.selectConsDocMngDList(params));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/checkConsBudgetModify" )
	public ModelAndView checkConsBudgetModify ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		logger.info( "checkConsBudgetModify" );
		ModelAndView mv = new ModelAndView( );
		try {
			mv.setViewName("jsonView");
			mv.addObject("cnt", consDocMngService.checkConsBudgetModify(params));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/consDocModify" )
	@ResponseBody
	public ModelAndView consDocModify ( @RequestBody Map<String, Object> params ) throws Exception {
		logger.info( "consDocModify" );
		ModelAndView mv = new ModelAndView( );
		try {
			mv.setViewName("jsonView");
			mv.addObject("result", consDocMngService.consDocModify(params));
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/getTreadList" )
	@ResponseBody
	public ModelAndView getTreadList ( @RequestBody Map<String, Object> params ) throws Exception {
		logger.info( "getTreadList" );
		ModelAndView mv = new ModelAndView( );
		try {
			mv.setViewName("jsonView");
			mv.addObject("result", consDocMngService.getTreadList(params));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping ( "/consDocMng/checkContract" )
	public ModelAndView checkContract ( @RequestParam Map<String, Object> params ) throws Exception {
		logger.info( "checkContract" );
		ModelAndView mv = new ModelAndView( );
		try {
			mv.setViewName("jsonView");
			mv.addObject("result", consDocMngService.checkContract(params));
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
}
