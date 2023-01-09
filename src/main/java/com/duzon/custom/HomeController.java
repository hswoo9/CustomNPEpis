package com.duzon.custom;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.common.dao.CommonDAO;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.CtEmpInfo;

/**
 * 테스트 컨트롤입니다.
 * 개발시 삭제해주세요.
 * @author iguns
 *
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Resource(name="CommonDAO")
	CommonDAO commonDAO;
	
	@Autowired
	private CommonService commonService;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
	
//		System.out.println(commonDAO.selectList("login.selectLoginHistoryList", null));
		
		
		
		return "/home";
	}
	
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Locale locale, Model model) {
		logger.info("Welcome index! The client locale is {}.", locale);
		
		
		return "index";
	}
	
	
	@RequestMapping(value = "/jsonTest", method = RequestMethod.GET)
	public ModelAndView jsonTest(Locale locale, Model model, HttpServletRequest sr) {
		logger.info("Welcome jsonTest! The client locale is {}.", locale);
		
		Map<String, Object> loginInfo = CtEmpInfo.getEmpInfo(sr);
		
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("result", "SUCCESS");
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
}
