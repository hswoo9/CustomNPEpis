package com.duzon.custom.approval.controller;

import bizbox.orgchart.service.vo.LoginVO;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.DateUtil;
import com.duzon.custom.eval.controller.EvalController;
import com.duzon.custom.eval.service.EvalService;
import com.google.gson.Gson;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import com.duzon.custom.approval.service.ApprovalService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class ApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(EvalController.class);
	private static final String BASE_DIR = "C:/Users/admin/git/DJ_EPIS/src/main/webapp/upload/";
	private static final String BASE_DOWN_DIR = "";

	@Autowired
	private ApprovalService approvalService;

	@Autowired
	private CommonService commonService;

	@Autowired
	private EvalService evalService;

	//상신 팝업
	@RequestMapping("/approval/approvalDraftingPop.do")
	public String approvalDraftingPop(@RequestParam Map<String, Object> params, Model model){

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", params);

		logger.info("return ********** /popup/approval/popup/approvalDraftingPop");
		logger.info("return ********** /popup/approval/popup/approvalDraftingPop");
		logger.info("return ********** /popup/approval/popup/approvalDraftingPop");

		return "/popup/approval/popup/approvalDraftingPop";
	}

	//기록물철 팝업
	@RequestMapping("/approval/approvalArchiveSelectPop.do")
	public String approvalArchiveSelectPop(HttpServletRequest request, Model model){
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		Map<String, Object> searchMap = new HashMap<>();
		searchMap.put("loginVO", loginVO);
		searchMap.put("deptSeq", loginVO.getOrgnztId());

		model.addAttribute("toDate", DateUtil.getToday(""));
		model.addAttribute("data", new Gson().toJson(approvalService.getArchiveTreeList(searchMap)));

		return "/popup/approval/popup/approvalArchiveSelectPop";
	}

	//결재선 지정
	@RequestMapping("/approval/approvalLineSettingPop.do")
	public String selectApprovalLine(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		model.addAttribute("data", commonService.ctDept(loginVO.getOrgnztId()));
		model.addAttribute("loginVO", loginVO);

		return "/popup/approval/popup/approvalLineSettingPop";
	}

	@RequestMapping("/approval/getUserInfo.do")
	public String getUserInfo(Model model, @RequestParam Map<String, Object> params){
		Map<String, Object> result = approvalService.getUserInfo(params);
		model.addAttribute("rs", result);
		return "jsonView";
	}

	//상신, 재상신
	@RequestMapping("/approval/setApproveDraftInit.do")
	public String setApproveDraftInit(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request, Model model) throws UnsupportedEncodingException {
		MultipartFile[] mpfList = request.getFiles("mpf").toArray(new MultipartFile[0]);
		MultipartFile docFile = request.getFile("docFilePdf");

		approvalService.setApproveDocInfo(params, docFile, mpfList, BASE_DIR, BASE_DOWN_DIR);

		return "jsonView";
	}

	//결재문서 상세보기
	@RequestMapping("/approval/approvalDocView.do")
	public String approvalDocView(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		//loginVO.setUniqId("1389");

		Map<String, Object> rs = evalService.getEvalCommOne(params);
		//Map<String, Object> rs = approvalService.getDocInfoApproveRoute(params);
		//rs.put("approveNowRoute", approvalService.getDocApproveNowRoute(params));
		//rs.put("cooperationNowRoute", approvalService.getDocCooperationNowRoute(params));

		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", params);
		model.addAttribute("rs", rs);

		return "/popup/approval/popup/approvalDocView";
	}

	//결재현황 리스트
	@RequestMapping("/approval/getDocApproveStatusHistList.do")
	public String getDocApproveHistList(@RequestParam Map<String, Object> params, Model model){
		model.addAttribute("rs", approvalService.getDocApproveStatusHistList(params));

		return "jsonView";
	}

	//의견 리스트
	@RequestMapping("/approval/getDocApproveHistOpinList.do")
	public String getDocApproveHistOpinList(@RequestParam Map<String, Object> params, Model model){
		model.addAttribute("rs", approvalService.getDocApproveHistOpinList(params));

		return "jsonView";
	}

	//결재상태 공통코드 조회
	@RequestMapping("/approval/getCmCodeInfo.do")
	public String getCmCodeInfo(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model) {
		model.addAttribute("rs", approvalService.getCmCodeInfo(params));
		return "jsonView";
	}

	//결재, 반려
	@RequestMapping("/approval/setDocApproveNRefer.do")
	public String setDocApproveNRefer(@RequestParam Map<String, Object> params, MultipartHttpServletRequest request, Model model) {
		MultipartFile docFile = request.getFile("docFilePdf");
		approvalService.setDocApproveNRefer(params, docFile);

		return "jsonView";
	}

	//결재문서 결재자 열람시간
	@RequestMapping("/approval/setDocApproveRouteReadDt.do")
	public String setDocApproveRouteReadDt(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model) {
		approvalService.setDocApproveRouteReadDt(params);
		return "jsonView";
	}

	//문서 회수
	@RequestMapping("/approval/setApproveRetrieve.do")
	public String setApproveRetrieve(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
		approvalService.setApproveRetrieve(params);

		return "jsonView";
	}

	//결재 상신 체크(운영,개발)
	@RequestMapping("/approval/approveCheck.do")
	public String approveCheck(@RequestParam Map<String, Object> map, HttpServletRequest request, Model model){

		model.addAttribute("cnt", approvalService.approveCheck(map));

		return "jsonView";
	}

}