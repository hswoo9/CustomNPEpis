package com.duzon.custom.main.controller;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 기본 레이아웃 입니다.
 * 
 * -----------------------
 *   GNB(defaultTop)
 * -----------------------
 *     |
 *     |
 * LNG |   Iframe(defaultIframe)
 *     |
 *     |
 *     
 * @author iguns
 *
 */
@Controller
public class LayoutController {
	
	private static final Logger logger = LoggerFactory.getLogger(LayoutController.class);
	
	@RequestMapping(value = "/layout/defaultIframe")
	public String defaultIframe(Locale locale, Model model) {
		logger.info("Welcome defaultIframe! The client locale is {}.", locale);
		
		
		return "/layout/defaultIframe";
	}
	
	@RequestMapping(value = "/layout/defaultTop")
	public String defaultTop(Locale locale, Model model) {
		logger.info("Welcome defaultTop! The client locale is {}.", locale);
		
		
		return "/layout/defaultTop";
	}
	
	@RequestMapping(value = "/layout/defaultLeft")
	public String defaultLeft(Locale locale, Model model) {
		logger.info("Welcome defaultLeft! The client locale is {}.", locale);
		
		
		return "/layout/defaultLeft";
	}
	
}
