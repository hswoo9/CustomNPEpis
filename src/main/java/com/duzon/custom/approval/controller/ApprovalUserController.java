package com.duzon.custom.approval.controller;

import bizbox.orgchart.service.vo.LoginVO;
import com.duzon.custom.approval.service.ApprovalUserService;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.DateUtil;
import com.google.gson.Gson;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ApprovalUserController {

	@Autowired
	private ApprovalUserService approvalUserService;

	@Autowired
	private CommonService commonService;

	/** 마이페이지 */

	//나의 결재선 관리
	@RequestMapping("/approvalUser/myApprLineManagement.do")
	public String myApprLineManagement(HttpServletRequest request, Model model){
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		model.addAttribute("loginVO", loginVO);
		model.addAttribute("data", commonService.ctDept((String) loginVO.getOrgnztId()));

		return "/approvalUser/myApprLineManagement";
	}

	//즐겨찾기 결재선 리스트 조회
	@RequestMapping("/approvalUser/getUserFavApproveRouteList.do")
	public String getUserFavApproveRouteList(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
		model.addAttribute("rs", approvalUserService.getUserFavApproveRouteList(params));
		return "jsonView";
	}

	//즐겨찾기 결재선 상세조회
	@RequestMapping("/approvalUser/getUserFavApproveRouteDetail.do")
	public String getUserFavApproveRouteDetail(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
		model.addAttribute("rs", approvalUserService.getUserFavApproveRouteDetail(params));
		return "jsonView";
	}

	//즐겨찾기 결재선 저장
	@RequestMapping("/approvalUser/setUserFavApproveRoute.do")
	public String setUserFavApproveRoute(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
		model.addAttribute("rs", approvalUserService.setUserFavApproveRoute(params));
		return "jsonView";
	}

	//즐겨찾기 결재선 삭제
	@RequestMapping("/approvalUser/setUserFavApproveRouteActiveN.do")
	public String setUserFavApproveRouteActiveN(@RequestParam(value = "favArr[]") List<String> favArr, HttpServletRequest request, Model model){
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> params = new HashMap<>();
		params.put("empSeq", loginVO.getUniqId());
		params.put("favArr", favArr);

		model.addAttribute("rs", approvalUserService.setUserFavApproveRouteActiveN(params));
		return "jsonView";
	}
}