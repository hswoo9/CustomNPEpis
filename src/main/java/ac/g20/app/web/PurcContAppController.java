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

import ac.g20.app.service.PurcContAppService;

@Controller
public class PurcContAppController {
	private static final Logger logger = LoggerFactory.getLogger(PurcContAppController.class);
	
	@Resource(name = "PurcContAppService")
	PurcContAppService purcContAppService;
	
	@RequestMapping(value = "/purcCont/purcContApp")
	public ModelAndView purcContApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcContAppService.updateDocState(bodyMap);
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
	
	@RequestMapping(value = "/purcCont/purcContAppSelect")
	public ModelAndView purcContAppSelect(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) {
		System.out.println(requestMap);
		ModelAndView mv = new ModelAndView();
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			Map<String, Object> resultMap = purcContAppService.purcContAppSelect(requestMap);
			mv.addObject("title", resultMap.get("contTitle"));
			mv.addObject("content", resultMap.get("contContent"));
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
	
	@RequestMapping(value = "/purcCont/purcContInspApp")
	public ModelAndView purcContInspApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcContAppService.updateInspDocState(bodyMap);
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
	
	@RequestMapping(value = "/purcCont/purcContInspAppSelect")
	public ModelAndView purcContInspAppSelect(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) {
		System.out.println(requestMap);
		ModelAndView mv = new ModelAndView();
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			Map<String, Object> resultMap = purcContAppService.purcContInspAppSelect(requestMap);
			mv.addObject("title", resultMap.get("docTitle"));
			mv.addObject("content", resultMap.get("docContent"));
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
	
	@RequestMapping(value = "/purcCont/purcContPayApp")
	public ModelAndView purcContPayApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcContAppService.updatePayDocState(bodyMap);
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
	
	@RequestMapping(value = "/purcCont/purcContPayAppSelect")
	public ModelAndView purcContPayAppSelect(@RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) {
		System.out.println(requestMap);
		ModelAndView mv = new ModelAndView();
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			Map<String, Object> resultMap = purcContAppService.purcContPayAppSelect(requestMap);
			mv.addObject("title", resultMap.get("title"));
			mv.addObject("content", resultMap.get("contents"));
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
	
	@RequestMapping(value = "/purcCont/purcContAppTEST")
	public ModelAndView purcContAppTEST(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			logger.info("================purcContAppTEST======================");
			logger.info("================purcContAppTEST======================");
			logger.info(bodyMap.toString());
			logger.info("================purcContAppTEST======================");
			logger.info("================purcContAppTEST======================");
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
	
	@RequestMapping(value = "/purcCont/purcContModApp")
	public ModelAndView purcContModApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			purcContAppService.updateModDocState(bodyMap);
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
