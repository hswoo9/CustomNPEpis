package com.duzon.custom.loginPage.controller;

import bizbox.orgchart.service.vo.LoginVO;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.loginPage.service.LoginPageService;
import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**

  * @FileName : LoginPageController.java

  * @Project : CustomNPTpf

  * @Date : 2018. 8. 21.

  * @작성자 : 김찬혁

  * @변경이력 :

  * @프로그램 설명 : 커스텀 로그인 화면 (지문인식)

  */
@Controller
public class LoginPageController {

private static final Logger logger = LoggerFactory.getLogger(LoginPageController.class);



	@Autowired
	private CommonService commonService;

	@Autowired
	private LoginPageService loginPageService;

	/**
		 * @MethodName : loginPage
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 커스텀 로그인 화면
		 */
	@RequestMapping(value="/loginPage", method = RequestMethod.GET)
	public String loginPage(Locale locale, Model model) throws NoPermissionException, UnknownHostException {

		String localIp = InetAddress.getLocalHost().getHostAddress();
		model.addAttribute("localIp", localIp);

		return "/login/loginPage";
	}

	/**
		 * @MethodName : securetKey
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 암호화 key 가져오기
		 */
	@RequestMapping(value = "/loginPage/secretKey", method = RequestMethod.POST)
	@ResponseBody
	public String securetKey(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException,
			UnknownHostException, InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException
			 {

		logger.info("securetKey");

		String result =  loginPageService.AES_Encode((String) map.get("key"));

		return result;
	}

	/**
		 * @MethodName : existUserYn
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 그룹웨어 id 등록 여부
		 */
	@RequestMapping(value = "/loginPage/existUserYn", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> existUserYn(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException, UnknownHostException {
		logger.info("existUserYn");

//		브라우저에서 서버 IP 반환
//		String localIp = InetAddress.getLocalHost().getHostAddress();
//		result.put("localIp", localIp);


		Map<String, Object> result =  loginPageService.existUserYn(map);

//		브라우저에서 로컬 IP 반환
	     String ip = servletRequest.getHeader("X-FORWARDED-FOR");

	     if (ip == null || ip.length() == 0) {
	         ip = servletRequest.getHeader("Proxy-Client-IP");
	     }

	     if (ip == null || ip.length() == 0) {
	         ip = servletRequest.getHeader("WL-Proxy-Client-IP");  // 웹로직
	     }

	     if (ip == null || ip.length() == 0) {
	         ip = servletRequest.getRemoteAddr() ;
	     }
	     result.put("localIp", ip);
//			브라우저에서 로컬 IP 반환

		return result;
	}

	/**
		 * @MethodName : getFingerKey
		 * @author : 김찬혁
		 * @since : 2018. 8. 21.
		 * 설명 : 지문 base64 key 가져오기
		 */
	@RequestMapping(value = "/loginPage/getFingerKey", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getFingerKey(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("getFingerKey");
		Map<String, Object> finger = commonService.getFingerBase64((String) map.get("id"));
		Map<String, Object> result =  new HashMap<String, Object>();
		if ( MapUtils.isEmpty(finger) ) {
			result.put("data", "empty");
		} else {
			result.putAll(finger);
		}


		return result;
	}

	@RequestMapping(value = "/loginPage/loginAgreementPop", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loginAgreementPop(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException{

		logger.info("securetKey");

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> status = loginPageService.loginAgreementPop(map);
		if ( MapUtils.isEmpty(status) ) {
			result.put("data", "empty");
		} else {
			result = loginPageService.loginAgreementPop(map);
		}

		return result;
	}

	@RequestMapping(value = "/loginPage/updateAgreement", method = RequestMethod.POST)
	@ResponseBody
	public String updateAgreement(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException{

		logger.info("securetKey");

		loginPageService.updateAgreement(map);

		return "ok";
	}

	@RequestMapping(value = "/loginPage/getCurrTime", method = RequestMethod.POST)
	@ResponseBody
	public String getCurrTime(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) {

		logger.info("getCurrTime");
		//loginPageService.getCurrTime(map);
		return loginPageService.getCurrTime(map);
	}

	@RequestMapping(value="/loginPage/loginSession.do")
	public String actionLogin(HttpServletRequest request, ModelMap model, @RequestParam Map<String,Object> paramMap) throws Exception {
		LoginVO resultVO = null;

		//compSeq
		//userId
		//groupSeq
		logger.info("loginSession.do");
		resultVO = loginPageService.actionLogin(paramMap);
		String userSe = resultVO.getUserSe();

		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			// 2-1. 로그인 정보를 세션에 저장
			logger.info("resultVO != null && resultVO.getId() != null && !resultVO.getId().equals()");
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("groupSeq", resultVO.getGroupSeq());
			mp.put("compSeq", resultVO.getOrganId());

			Map<String, Object> optionSet = loginPageService.selectOptionSet(mp);
			request.getSession().setAttribute("optionSet", optionSet);
			request.getSession().setAttribute("loginVO", resultVO);
			request.setAttribute("langCode", resultVO.getLangCode());
		}

		if(paramMap.containsKey("view")){
			return "jsonView";
		}

		if(paramMap.containsKey("redirectUrl")){
			return "redirect:" + paramMap.get("redirectUrl");
		}else{
			model.addAttribute("paramMap", paramMap);
			return "/busTrip/loginSession";
		}
	}

	@RequestMapping(value="/custom/empInfoSaveProc.do")
	public String empInfoSaveProc(HttpServletRequest request, ModelMap model, @RequestParam Map<String,Object> paramMap) throws Exception {
		LoginVO resultVO = null;
		logger.info("loginSession.do");
		resultVO = loginPageService.actionLogin(paramMap);
		String userSe = resultVO.getUserSe();

		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			// 2-1. 로그인 정보를 세션에 저장
			logger.info("resultVO != null && resultVO.getId() != null && !resultVO.getId().equals()");
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("groupSeq", resultVO.getGroupSeq());
			mp.put("compSeq", resultVO.getOrganId());

			Map<String, Object> optionSet = loginPageService.selectOptionSet(mp);
			request.getSession().setAttribute("optionSet", optionSet);
			request.getSession().setAttribute("loginVO", resultVO);
			request.setAttribute("langCode", resultVO.getLangCode());
		}

		model.addAttribute("paramMap", paramMap);
		return "/busTrip/empInfoSaveProc";
	}
}
