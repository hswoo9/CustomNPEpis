package ac.g20.app.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import ac.g20.app.service.PurcReqAppService;

@Controller
public class PurcReqAppController {
	private static final Logger logger = LoggerFactory.getLogger(PurcReqAppController.class);
	
	@Resource(name = "PurcReqAppService")
	PurcReqAppService purcReqAppService;
	
	@RequestMapping(value = "/purcReq/purcReqApp")
	public ModelAndView purcReqApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcReqAppService.updateDocState(bodyMap);
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
	
	@RequestMapping(value = "/purcReq/purcReqAppSelect")
	public ModelAndView purcReqAppSelect(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) {
		System.out.println(requestMap);
		ModelAndView mv = new ModelAndView();
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			Map<String, Object> resultMap = purcReqAppService.purcReqAppSelect(requestMap);
			mv.addObject("title", resultMap.get("purcReqTitle"));
			mv.addObject("content", resultMap.get("purcReqContent"));
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
	
	@RequestMapping(value = "/purcReq/purcReqBiddingApp")
	public ModelAndView purcReqBiddingApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcReqAppService.purcReqBiddingApp(bodyMap);
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
}
